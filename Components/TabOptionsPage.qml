import QtQuick 2.5

Page {
    id: root
    //imageSource: "options-bg.png"
    property alias backbutton: hdr.leftButtonVisible
    property alias confirmbutton: hdr.rightButtonVisible
    property alias rightbutton: hdr.rightButtonVisible
    property alias rightbuttonsrc: hdr.rightButtonSource
    property alias title: hdr.text
    property alias showheader: titlebar.visible
    property Item tabs
    property Item background
    property bool allowalldown: true
    property int raised: allowalldown? -1 : 0
    //height: parent.height    // TODO: this seem to be undefined for several pages, how to fix?
    //width: parent.width      // TODO: this seem to be undefined for several pages, how to fix?
    //height: parent? parent.height : 0
    //width:  parent? parent.width  : 0
    //x: 0
    //y: 0
    property alias mycontent: content

    signal confirm()
    signal rightClicked()

    function cancel() {
        pageStack.pop();
    }

    Item {
        id: titlebar
        x: 0
        y: 0
        width:  visible? root.width : 0
        height: visible? (root.width>root.height? root.height/8: root.width/8) : 0
    }

    Item {
        id: content
        x: 0
        y: titlebar.height
        z: 10
        width: root.width
        height: root.height-titlebar.height

        //onXChanged:      console.log("TabOptionPage.content.onXChanged:      ",x,y,width,height)
        //onYChanged:      console.log("TabOptionPage.content.onYChanged:      ",x,y,width,height)
        //onWidthChanged:  console.log("TabOptionPage.content.onWidthChanged:  ",x,y,width,height)
        //onHeightChanged: console.log("TabOptionPage.content.onHeightChanged: ",x,y,width,height)
        onWidthChanged: root.layoutPage()
        onHeightChanged: root.layoutPage()
    }

/*
    Flickable {
        x: 0
        y: titlebar.height
        z: 10
        width: root.width
        height: root.height-titlebar.height
        contentWidth: content.width
        contentHeight: content.height
        interactive: contentHeight > height? true: false
        clip: true
        Item {
            id: content
            anchors.fill: parent
            onWidthChanged: root.layoutPage()
            onHeightChanged: root.layoutPage()
        }
    }
*/
    property Item header: OptionHeader {
        id: hdr
        visible: true
        text: "Options"
        leftButtonVisible: true
        onLeftClicked: root.cancel();
        rightButtonVisible: false
        rightButtonSource: "visible.png"
        onRightClicked: { root.confirm(); root.rightClicked(); }
        buttonheight: root.width>root.height? root.height/8: root.width/8
    }

    function layoutPage() {
        if (header)     layoutHeader()
        if (background) layoutBackground()
        if (tabs)       layoutTabs()
    }

    function layoutHeader() {
        header.parent = titlebar;
        header.anchors.fill = titlebar;
    }

    function layoutBackground() {
        background.parent = content
        background.z = 2
    }

    function layoutTabs() {
        console.log("TabOptionsPage.layoutTabs(): got", tabs.children.length, "tabs", tabs.width, tabs.height)
        var count = tabs.children.length
        var tx = 13

        for (var i=0; i<count; ++i) {
            var tab = tabs.children[i]

            tab.index = i
            //tab.parent = content
            tab.titlex = tx
            tab.x = 0
            tab.width = tabs.width
            tab.height = tabs.height
            tab.y = (i<=root.raised)? 6 : tabs.height - tab.titleheight - 6
            //tab.z = (i==raised)? 9 : 10 + count - i
            tab.z = 10

            tx = tx + tab.titlewidth + 3
        }
    }

    function initTabs() {
        if (tabs) {
            var count = tabs.children.length
            //console.log("TabOptionsPage.initTabs() count:",count)
            tabs.parent = content
            tabs.z = 5

            for (var i=0; i<count; ++i) {
                var tab = tabs.children[i]
                tab.clicked.connect(tabSelected)
            }
            layoutPage()
        }
        else
        {
            //console.log("TabOptionsPage.initTabs() tabs is undefined!")
        }

        tabs.xChanged.connect(layoutPage)
        tabs.yChanged.connect(layoutPage)
        tabs.widthChanged.connect(layoutPage)
        tabs.heightChanged.connect(layoutPage)
    }

    function tabSelected(index) {
        if (allowalldown && (root.raised === index)) {
            //console.log("TabOptionsPage.tabSelected(): unselect",index,tabs.children[index].title)
            root.raised = -1
        } else {
            //console.log("TabOptionsPage.tabSelected(): select  ",index,tabs.children[index].title)
            root.raised = index
        }
        layoutTabs()
    }

    //onXChanged:            { layoutPage(); console.log("TabOptionPage.onXChanged()        ",x,y,width,height) }
    //onYChanged:            { layoutPage(); console.log("TabOptionPage.onYChanged()        ",x,y,width,height) }
    //onWidthChanged:        { layoutPage(); console.log("TabOptionPage.onWidthChanged()    ",x,y,width,height) }
    //onHeightChanged:       { layoutPage(); console.log("TabOptionPage.onHeightChanged()   ",x,y,width,height) }
    //onTabsChanged:         { initTabs();   console.log("TabOptionPage.onTabsChanged()     ",x,y,width,height) }
    //Component.onCompleted: { layoutPage(); console.log("TabOptionPage.onCompletedChanged()",x,y,width,height) }
    onTabsChanged:         initTabs()
    //Component.onCompleted: initTabs()
}

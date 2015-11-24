import QtQuick 2.0

Item {
    id: root
    property int startx: 5
    property int spacing: 2
    property int selected: 0

    default property alias _tempcontent: _temp.children
    Item { id: _temp }
    property var content: []

    on_TempcontentChanged: move()
    Component.onCompleted: layout()

    onWidthChanged: layout()
    onHeightChanged: layout()
    onContentChanged: layout()

    Item { id: _content; anchors.fill: parent; }

    function move() {
        if (_tempcontent.length === 0)
            return

        for (var i=0; i<_tempcontent.length; i++) {
            addTab(_tempcontent[i])
        }
        contentChanged()
    }

    function addTab(value) {
        if (value) {
            console.log("OptionTabsLayout.addTab",value.title)
            content.push(value)
        }
        value.parent = _content
    }

    function layout() {
        move()

        console.log("OptionTabsLayout.layout() length:",content.length,"window:",x,y,width,height)
        var xpos = startx
        for (var i=0; i<content.length; i++) {
            if (content[i]) {
                // Assume OptionTab
                content[i].x = 0
                content[i].y = 0
                content[i].width = width
                content[i].height = height
                content[i].index = i
                content[i].selected = false
                content[i].tabx = xpos
                content[i].tabSelected.connect(root.selectTab)
                content[i].parent = root
                xpos = content[i].tabx + content[i].tabwidth + spacing

                console.log("OptionTabsLayout.layout",i,content[i].name,content[i].tabx,content[i].tabwidth)
            }
        }

        selectTab(selected)
    }

    function selectTab(value) {
        console.log("OptionTabsLayout.selectTab",value)
        for (var i=0; i<content.length; i++)
            if (content[i])
                content[i].selected = (content[i].index === value)
            else
                console.log("Unkown item",content[i])
    }
}

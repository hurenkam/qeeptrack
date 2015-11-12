import QtQuick 2.5
import QtQuick.Window 2.2

Item {
    id: root
    property int index: -1
    property alias title: header.text
    property alias titlewidth:  tab.width
    property alias titleheight: tab.height
    property alias titlex: tab.x
    property alias titley: tab.y
    property string imageSource: "options-bg.png"
    default property alias children: content.children
    width: parent.width

    //onXChanged:      console.log("TabItem.onXChanged:      ",x,y,width,height)
    //onYChanged:      console.log("TabItem.onYChanged:      ",x,y,width,height,title)
    //onWidthChanged:  console.log("TabItem.onWidthChanged:  ",x,y,width,height)
    //onHeightChanged: console.log("TabItem.onHeightChanged: ",x,y,width,height)

    Behavior on y {
        enabled: true
        NumberAnimation { easing.type: Easing.InOutQuart; duration: 300 }
    }

    signal clicked  (int index)
    signal pressed  (int index)
    signal released (int index)

    Item {
        x: 0
        y: tab.height
        width: parent.width
        height: parent.height - tab.height
        Rectangle {
            anchors.fill: parent
            radius: 12
            color: "white"
            border.color: "grey"
            border.width: 1
            clip: true
            smooth: true

            Image {
                anchors.fill: parent
                anchors.margins: 4
                visible: (source != "")
                source: root.imageSource
                fillMode: Image.Tile
            }
        }
        Flickable {
            id: flickable
            x:0
            y:0
            width: root.width
            height: root.height
            contentWidth: content.width
            contentHeight: content.height
            interactive: contentHeight > height? true: false
            clip: true

            Item {
                id: content
                width: flickable.width
                height: childrenRect.height+50
                //onWidthChanged: console.log("TabItem.Item.Flickable.Item.onWidthChanged: ",width,height)
                //onHeightChanged: console.log("TabItem.Item.Flickable.Item.onHeightChanged: ",width,height)
                //Component.onCompleted: console.log("TabItem.Item.Flickable.Item.onCompleted: ",width,height)
            }
            //onWidthChanged: console.log("TabItem.Item.Flickable.onWidthChanged: ",width,height)
            //onHeightChanged: console.log("TabItem.Item.Flickable.onHeightChanged: ",width,height)
            //Component.onCompleted: console.log("TabItem.Item.Flickable.onCompleted: ",width,height)
        }
/*
        Item {
            anchors.fill: parent
            anchors.margins: 4
            id: content
        }
*/
    }

    Item {
        id: tab
        x: 0
        y: 0
        width: header.width+13
        height: header.height+3

        MouseArea {
            //anchors.fill:  parent
            x: -2; y:-15
            width: parent.width +4
            height: parent.height +20
            onClicked: root.clicked(root.index)
            onPressed: root.pressed(root.index)
            onCanceled: root.released(root.index)
            onReleased: root.released(root.index)
        }

        Rectangle {
            id: toprect
            //anchors.fill: parent
            x:0; y: 3
            width: parent.width
            height: parent.height-3
            radius: 12
            color: "white"
            border.color: "grey"
            border.width: 1
        }

        Rectangle {
            id: bottomrect
            x: 1; width: parent.width-1
            y: parent.height-12
            height: 13
            color: "white"

            Rectangle {
                x: -1; width: 1
                y: 0
                height: parent.height
                color: "grey"
            }
            Rectangle {
                x: parent.width; width: 1
                y: 0
                height: parent.height
                color: "grey"
            }
        }

        Text {
            id: header
            x: 6
            y: 3
            color: "black"
            text: "tab"
            font.pointSize: screen.pointSize
        }
    }
    //onWidthChanged:        { console.log("TabItem.onWidthChanged()    ",x,y,width,height) }
    //onHeightChanged:       { console.log("TabItem.onHeightChanged()   ",x,y,width,height) }
    //Component.onCompleted: { console.log("TabItem.onCompleted()       ",x,y,width,height) }
}

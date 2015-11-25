import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
    id: root
    anchors.fill: parent

    property string name: "tab"
    property int index: -1
    property bool selected: false
    property int tabx: 0
    property int taby: 0
    property int tabwidth: tab.width
    property int tabheight: tab.height
    property string imageSource: "qrc:/Components/options-bg.png"
    default property alias _content: content.children

    signal tabSelected(int value)

    function addBox(value) {
        value.parent = content
    }

    Item {
        id: tab
        x: tabx
        y: taby
        width: title.width+10
        height: title.height+5
        clip: true
        smooth: true

        Rectangle {
            x: 0
            y: selected? 0:2
            width: title.width+10
            height: parent.height + 12
            color: "white"
            radius: 12
            border.color: selected? "black": "grey"

            Text {
                id: title
                x: 5
                y: 5
                text: root.name
                color: selected? "black": "grey"
                font.pointSize: screen.pointSize
            }

            MouseArea {
                anchors.fill: parent
                onClicked: tabSelected(root.index)
            }
        }
    }

    Rectangle {
        id: tabcontent
        x: 0
        y: tab.y + tab.height
        width: parent.width
        height: parent.height -y
        color: "white"
        visible: selected
        border.color: "black"

        Rectangle {
            x: tab.x+1
            y: 0
            width: tab.width-2
            height: 1
            color: "white"
        }

        Image {
            anchors.fill: parent
            anchors.margins: 4
            visible: (source != "")
            source: root.imageSource
            fillMode: Image.Tile
        }

        GridLayout {
            id: content
            x: 10
            y: 10
            width: parent.width - 20
            columns: screen.portrait? 1 : 2
        }
    }
}

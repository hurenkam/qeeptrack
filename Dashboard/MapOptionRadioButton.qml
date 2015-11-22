import QtQuick 2.0

MapOptionItem {
    id: root
    width: parent.width
    height: title.height+14
    property string text: ""
    property int index: -1
    property int selected: -2

    signal ticked(int value)
    function updateSelected(value) {
        selected = value
    }

    Text {
        id: title
        x: 0
        y: 6
        width: parent.width - button.width -10
        text: root.text
        color: "black"
        font.pointSize: screen.pointSize
        clip: true
    }

    Image {
        id: button
        x: parent.width - width
        y: 2
        height: title.height+4
        width: height
        source: (root.index === root.selected)? "qrc:/Components/ticked.png" : "qrc:/Components/unticked.png"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: ticked(root.index)
    }
}


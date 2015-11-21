import QtQuick 2.0

MapOptionItem {
    id: root
    property string text: ""

    Text {
        id: title
        x: 0
        y: 0
        width: parent.width - button.width
        text: root.text
        color: "black"
        font.pointSize: screen.pointSize
    }
}


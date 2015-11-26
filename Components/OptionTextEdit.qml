import QtQuick 2.5

OptionItem {
    id: root
    width: parent.width
    height: titletext.height+14
    property string title: ""
    property string value : ""

    Text {
        id: titletext
        x: 0
        y: 4
        text: root.title
        color: "black"
        font.pointSize: screen.pointSize
        clip: true
    }

    Text {
        id: valuetext
        x: parent.width - valuetext.width -5
        y: 4
        text: root.value
        color: "grey"
        font.italic: true
        font.pointSize: screen.pointSize
        clip: true
    }
}

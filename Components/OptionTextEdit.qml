import QtQuick 2.5

OptionItem {
    id: root
    width: parent.width
    height: titletext.height+14
    property string title: ""
    property alias value: valuetext.text

    Text {
        id: titletext
        x: 0
        y: 4
        text: root.title
        color: "black"
        font.pointSize: screen.pointSize
        clip: true
    }

    TextInput {
        id: valuetext
        x: titletext.width + 4
        width: parent.width - titletext.width - 12
        horizontalAlignment: TextEdit.AlignRight
        y: 4
        text: ""
        color: "grey"
        font.italic: true
        font.pointSize: screen.pointSize
        clip: true
    }
}

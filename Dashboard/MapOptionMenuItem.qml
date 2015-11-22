import QtQuick 2.5

MapOptionItem {
    id: root
    width: parent.width
    height: title.height+14
    property string text: ""

    signal clicked()

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
        source: "qrc:/Components/forward.png"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}


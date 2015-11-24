import QtQuick 2.5

OptionItem {
    id: root
    width: parent.width
    height: titletext.height+14
    property string title: ""
    property string subtitle: submenu? submenu.selectedvalue : ""
    property OptionsPage submenu

    signal clicked()

    Text {
        id: titletext
        x: 0
        y: 6
        text: root.title
        color: "black"
        font.pointSize: screen.pointSize
        clip: true
    }

    Text {
        id: subtitletext
        x: button.x - subtitletext.width -5
        y: 6
        text: root.subtitle
        color: "grey"
        font.italic: true
        font.pointSize: screen.pointSize
        clip: true
    }

    Image {
        id: button
        x: parent.width - width
        y: 2
        height: titletext.height+4
        width: height
        source: "qrc:/Components/forward.png"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (root.submenu)
                stack.push(root.submenu)
            else
                root.clicked()
        }
    }
}

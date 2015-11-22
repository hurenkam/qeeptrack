import QtQuick 2.5
import QtQuick.Layouts 1.1

Rectangle {
    id: root
    color: "white"
    border.color: "grey"
    border.width: 1
    radius: 12
    clip: true
    smooth: true

    property string title: ""
    default property alias items: column.children
    property Item columnlayout: column

    Layout.preferredHeight: column.height + titlewidget.height + 15
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignTop

    Text {
        x: 10
        y: 5
        id: titlewidget
        font.bold: true
        font.pointSize: screen.pointSize
        text: root.title
    }

    ColumnLayout {
        id: column
        x: 0
        y: 10 + titlewidget.height
        width: parent.width
        height: childrenRect.height
        spacing: 0
    }
}

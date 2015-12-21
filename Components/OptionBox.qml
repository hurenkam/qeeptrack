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
    property int titleheight: titlewidget.height
    property bool titlevisible: titlewidget.visible
    default property alias items: column.children
    property Item columnlayout: column

    Layout.preferredHeight: titlewidget.visible? column.height + titlewidget.height + 15: column.height + 10
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignTop

    Text {
        x: 10
        y: 5
        id: titlewidget
        font.bold: true
        font.pointSize: screen.pointSize
        text: root.title
        visible: (root.title != "")
    }

    Rectangle {
        x: 0
        y: column.y-2
        width: parent.width
        height: 1
        color: "grey"
        visible: titlewidget.visible
    }

    ColumnLayout {
        id: column
        x: 0
        y: titlewidget.visible? 10 + titlewidget.height: 5
        width: parent.width
        //height: childrenRect.height
        spacing: 0
    }

    function addLines() {
        var ypos = 0
        for (var i=0; i<(children.length-1); i++) {
            console.log("OptionBox.addLines()",i)
        }
    }

    function confirm(callback) {
        callback()
    }

    Component.onCompleted: addLines()
    onChildrenChanged: addLines()
}

import QtQuick 2.5
import QtQuick.Layouts 1.1

Item {
    id: root
    property string title: ""
    property string imageSource: "qrc:/Components/options-bg.png"
    default property alias items: column.children

    Rectangle {
        anchors.fill: parent
        color: "white"
        border.color: "grey"
        border.width: 1
        radius: 12
        clip: true
        smooth: true

        Image {
            anchors.fill: parent
            anchors.margins: 4
            visible: (source != "")
            source: root.imageSource
            fillMode: Image.Tile
        }

        ColumnLayout {
            id: column
            x: 10
            y: 10
            width: parent.width - 20
            spacing: 10
        }
    }
}

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import "qrc:/Dashboard"

ApplicationWindow {
    visible: true
    visibility: "FullScreen"
    width: 640
    height: 480
    title: qsTr("Tryios")

    Dashboard {
        width: parent.width
        height: parent.height
        x: 0
        y: 0
    }

    ToolButton {
        width: 40
        height: 40
        x: parent.width - 42
        y: 2
        Image {
            source: "qrc:/Buttons/exit.png"
            anchors.fill:parent
        }
        onClicked: Qt.quit();
    }
}


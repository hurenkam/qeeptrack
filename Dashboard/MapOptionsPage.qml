import QtQuick 2.0
import "qrc:/Components"

Page {
    id: root
    anchors.fill: parent
    color: "white"

    property string title: "Options"

    function cancel() {
        pagestack.pop();
    }

    function confirm() {
        pagestack.pop()
    }

    Item {
        x: 20 + buttonwidth
        y: 10
        width: parent.width - 2* (20+buttonwidth)
        height: buttonwidth

        Text {
            anchors.centerIn: parent
            id: titlewidget
            font.bold: true
            font.pointSize: screen.pointSize*10/8
            text: root.title
        }
    }

    ToolButton {
        id: leftbutton
        x: 10; y:10
        width: buttonwidth
        height: width

        bgcolor: "white"
        source: "qrc:/Gauges/backc.png";
        onClicked: {
            console.log("MapOptions.onCancel")
            root.cancel();
        }
    }

    ToolButton {
        id: rightbutton

        x: root.width - 10 -buttonwidth; y:10
        width: buttonwidth
        height: width

        source: "qrc:/Gauges/confirmc.png";
        bgcolor: "white"

        onClicked: {
            console.log("MapOptions.onConfirm")
            root.confirm();
            saveSettings()
        }
    }
}

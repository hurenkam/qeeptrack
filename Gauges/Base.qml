import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string prefix: ""
    property string name: ""
    property string dialimagesource
    property string shorthandimagesource
    property string longhandimagesource
    property string secondhandimagesource
    property int divider: 1000
    property int digits: 1
    property int shorthanddivider: 100
    property int longhanddivider: 10
    property int secondhanddivider: 1

    SettingsDatabase {
        id: settings
        filename: "qeeptrack"
        prefix: root.prefix

        Component.onCompleted: root.loadSettings()
    }

    property list<QtObject> sources
    property list<QtObject> targets: [
        Item { id: analog; property string name: "Analog";  property int mode: 0; property var value: sources[mode].value
            function setMode(value,name) { mode = value } },
        Item { id: top;    property string name: "Top";     property int mode: 1; property var value: sources[mode].value
            function setMode(value,name) { mode = value } },
        Item { id: bottom; property string name: "Bottom";  property int mode: 2; property var value: sources[mode].value
            function setMode(value,name) { mode = value } }
    ]

    property var analogvalue: analog.value
    property var topvalue:    top.value
    property var bottomvalue: bottom.value

    property double shortangle:  -180 + analog.value/(root.shorthanddivider*root.divider) * 360
    property double longangle:   -180 + analog.value/(root.longhanddivider*root.divider) * 360
    property double secondangle: -180 + analog.value/(root.secondhanddivider*root.divider) * 360
    property string topstring:    root.toFixed(top.value/root.divider,root.digits)
    property string bottomstring: root.toFixed(bottom.value/root.divider,root.digits)

    function loadSettings() {
        analog.mode = settings.getValue("analog.mode","0")
        top.mode = settings.getValue("top.mode","1")
        bottom.mode = settings.getValue("bottom.mode","2")
    }

    function saveSettings() {
        settings.setValue("analog.mode",analog.mode.toString())
        settings.setValue("top.mode",top.mode.toString())
        settings.setValue("bottom.mode",bottom.mode.toString())
    }

    function toFixed(num,count) {
        var s = num.toFixed(count).toString();
        return s;
    }

    Image {
        source: "qrc:/Gauges/gauge-faceplate-white.png";
        anchors.fill: parent
    }
    Image {
        source: root.dialimagesource
        anchors.fill: parent

        Text {
            id: nametext
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.3
            text: root.name;
            color: "black"
            font.bold: true; font.pixelSize: parent.height/3* 0.18
            style: Text.Raised; styleColor: "black"
        }
    }

    Rectangle {
        y: parent.height * 0.7
        height: parent.height * 0.16
        color: "#e0e0e0"
        width: parent.width/4
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            //id: top
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 2
            text: topstring
            color: "black"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "white"
        }
        Text {
            //id: bottom
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 2
            text: bottomstring
            color: "black"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "white"
        }
    }

    Image {
        source: root.shorthandimagesource
        anchors.fill: parent
        transform: Rotation {
            id: shorthand
            origin.x: width/2
            origin.y: height/2
            angle: shortangle
            Behavior on angle {
                id: shorthandanimation
                enabled: false
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }

    Image {
        source: root.longhandimagesource
        anchors.fill: parent
        transform: Rotation {
            id: longhand
            origin.x: width/2
            origin.y: height/2
            angle: longangle
            Behavior on angle {
                id: longhandanimation
                enabled: false
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }

    Image {
        source: root.secondhandimagesource
        anchors.fill: parent
        transform: Rotation {
            id: secondhand
            origin.x: width/2
            origin.y: height/2
            angle: secondangle
            Behavior on angle {
                id: secondhandanimation
                enabled: false
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }
}

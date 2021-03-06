import QtQuick 2.5
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string prefix: "qeeptrack.compass."
    property string name: "compass"

    SettingsDatabase {
        id: settings
        filename: "qeeptrack"
        prefix: root.prefix

        Component.onCompleted: root.loadSettings()
    }

    property list<QtObject> sources
    property list<QtObject> targets: [
        Item {
            id: dial;
            property string name: "Dial";
            property int mode: 0;
            property double value: up.value + sources[mode].value
            function setMode(value,name) { mode = value }
        },
        Item {
            id: needle;
            property string name: "Needle";
            property int mode: 1;
            property double value: up.value + sources[mode].value
            function setMode(value,name) { mode = value }
        },
        Item {
            id: up;
            property string name: "Up";
            property int mode: 1;
            property double value: 360 - sources[mode].value
            function setMode(value,name) { mode = value }
        },
        Item {
            id: ring;
            property string name: "Ring";
            property int mode: 3;
            property double value: up.value + sources[mode].value
            function setMode(value,name) { mode = value }
        }
    ]

    function loadSettings() {
        dial.mode = settings.getValue("dial.mode","0")
        needle.mode = settings.getValue("needle.mode","1")
        up.mode = settings.getValue("up.mode","1")
        ring.mode = settings.getValue("ring.mode","3")
    }

    function saveSettings() {
        settings.setValue("dial.mode",dial.mode.toString())
        settings.setValue("needle.mode",needle.mode.toString())
        settings.setValue("up.mode",up.mode.toString())
        settings.setValue("ring.mode",ring.mode.toString())
    }

    Image {
        source: "qrc:/Gauges/gauge-faceplate-white.png";
        anchors.fill: parent
    }
    Image {
        source: "qrc:/Gauges/compass-ring-white.png"
        anchors.fill: parent
        transform: Rotation {
            origin.x: width/2
            origin.y: height/2
            angle: ring.value
        }
    }

    Image {
        source: "qrc:/Gauges/compass-rose-black.png"
        anchors.fill: parent
        transform: Rotation {
            origin.x: width/2
            origin.y: height/2
            angle: dial.value
        }
    }

    Image {
        source: "compassneedle.png"
        anchors.fill: parent
        transform: Rotation {
            origin.x: width/2
            origin.y: height/2
            angle: needle.value
        }
    }
}

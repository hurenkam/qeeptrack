import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string name:                  "speed (km/h)"
    property string dialimagesource:       ((analog.value>10) || (maximum.source>10))? "speed200.png" : "speed10.png"
    property string shorthandimagesource:  "speedneedle.png"
    property string longhandimagesource:   null
    property string secondhandimagesource: null
    property int divider: 1
    property int digits: 0

    property list<QtObject> sources: [
        Item { id: current; property string name: "Current Speed";  property double source: speedmodel.current },
        Item { id: average; property string name: "Average Speed";  property double source: monitormodel.averageSpeed },
        Item { id: minimum; property string name: "Minimum Speed";  property double source: speedmodel.minimum },
        Item { id: maximum; property string name: "Maximum Speed";  property double source: speedmodel.maximum }
    ]

    property list<QtObject> targets: [
        Item { id: analog; property string name: "Analog";  property int mode: 0; property double value: sources[mode].source },
        Item { id: top;    property string name: "Top";     property int mode: 1; property double value: sources[mode].source },
        Item { id: bottom; property string name: "Bottom";  property int mode: 2; property double value: sources[mode].source }
    ]

    function toFixed(num,count) {
        var s = num.toFixed(count).toString();
        return s;
    }

    property Item optiontabs: TabLayout {
        id: tablayout

        TabItem {
            title: "Analog"
        }
        TabItem {
            title: "Digital Top"
        }
        TabItem {
            title: "Digital Bottom"
        }
    }

    Image {
        source: dialimagesource
        width: parent.width
        height: parent.height

        Text {
            id: nametext
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.3
            text: root.name;
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3* 0.18
            style: Text.Raised; styleColor: "black"
        }
    }

    Rectangle {
        y: parent.height * 0.75
        height: parent.height * 0.16
        color: "black"
        width: parent.width/4
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(top.value,1)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
        Text {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(bottom.value,1)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
    }

    Image {
        source: "speedneedle.png"
        width: parent.width
        height: parent.height
        transform: Rotation {
            id: needle
            origin.x: width/2
            origin.y: height/2
            angle: ((analog.value<10) && (maximum.source<10))? analog.value/10*360 -180: analog.value/200*360 -180
        }
    }
}

import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string name: "distance (km)"
    property string dialimagesource: "speed10.png"
    property string shorthandimagesource: "shorthand.png"
    property string longhandimagesource: "longhand.png"
    property string secondhandimagesource: "secondhand.png"
    property int divider: 1000
    property int digits: 1

    property list<QtObject> sources: [
        Item { property string name: "Trip Distance";       property double source: monitormodel.tripDistance },
        Item { property string name: "Total Distance";      property double source: monitormodel.totalDistance },
        Item { property string name: "Remaining Distance";  property double source: monitormodel.remainingDistance }
    ]

    property list<QtObject> targets: [
        Item { id: analog; property string name: "Analog";  property int mode: 0; property double value: sources[mode].source },
        Item { id: top;    property string name: "Top";     property int mode: 1; property double value: sources[mode].source },
        Item { id: bottom; property string name: "Bottom";  property int mode: 2; property double value: sources[mode].source }
    ]

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

    function toFixed(num,count) {
        var s = num.toFixed(count).toString();
        return s;
    }

    Image {
        source: root.dialimagesource
        anchors.fill: parent

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
            //id: top
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(top.value/root.divider,root.digits)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
        Text {
            //id: bottom
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(bottom.value/root.divider,root.digits)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
    }

    Image {
        source: root.shorthandimagesource
        anchors.fill: parent
        transform: Rotation {
            id: shorthand
            origin.x: width/2
            origin.y: height/2
            angle: -180 + analog.value/(100*root.divider) * 360
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
            angle: -180 + analog.value/(10*root.divider) * 360
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
            angle: -180 + analog.value/root.divider * 360
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

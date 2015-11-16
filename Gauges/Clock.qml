import QtQuick 2.5
import QtQuick.Window 2.2
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent
    property bool enableanimations: false

    property string name: "clock"
    property list<QtObject> sources: [
        Item { id: currenttime;   property string name: "Current Time";   property date source: clockmodel.time },
        Item { id: elapsedtime;   property string name: "Elapsed Time";   property date source: clockmodel.elapsed },
        Item { id: remainingtime; property string name: "Remaining Time"; property date source: monitormodel.remainingTime }
    ]

    property list<QtObject> targets: [
        Item { id: analog; property string name: "Analog"; property int mode: 0; property date value: sources[mode].source
            function setMode(value,name) { disableAnimations(); analog.mode = value; console.log("analog.setMode() New mode:",value) } },
        Item { id: top;    property string name: "Top";    property int mode: 1; property date value: sources[mode].source
            function setMode(value,name) { disableAnimations(); top.mode = value; console.log("top.setMode() New mode:",value) } },
        Item { id: bottom; property string name: "Bottom"; property int mode: 2; property date value: sources[mode].source
            function setMode(value,name) { disableAnimations(); bottom.mode = value; console.log("bottom.setMode() New mode:",value) } }
    ]

    Timer {
        id: timer
        interval: 50;
        running: true;
        repeat: false;

        onTriggered: {
            enableanimations = true
        }
    }

    function disableAnimations() {
        root.enableanimations = false
        timer.running = true
    }

    Image {
        source: "clock.png";
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
        y: parent.height * 0.7
        height: parent.height * 0.18
        color: "black"
        width: parent.width/3.5
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: toptext
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(top.value,"hh:mm:ss");
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
        Text {
            y: parent.height/2
            id: bottomtext
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(bottom.value,"hh:mm:ss");
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
    }

    Image {
        source: "shorthand.png"
        anchors.fill: parent
        transform: Rotation {
            id: shorthand
            origin.x: width/2
            origin.y: height/2
            angle: analog.value.getHours()*360/12 + analog.value.getMinutes()/2
        }
    }

    Image {
        source: "longhand.png"
        anchors.fill: parent
        transform: Rotation {
            id: longhand
            origin.x: width/2
            origin.y: height/2
            angle: analog.value.getMinutes()*360/60 + analog.value.getSeconds()/10
        }
    }

    Image {
        source: "secondhand.png"
        anchors.fill: parent
        transform: Rotation {
            id: secondhand
            origin.x: width/2
            origin.y: height/2
            angle: analog.value.getSeconds()*360/60
            //angle: (analog.value.getSeconds() * 1000 + analog.value.getMilliseconds()) * 360/60000
            Behavior on angle {
                id: secondhandanimation
                enabled: root.enableanimations
                SpringAnimation {
                    velocity: 6
                    modulus: 360
                }
            }
        }
    }
}

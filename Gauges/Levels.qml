import QtQuick 2.5
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string prefix: ""
    property int compass:     0
    property int battery:     0
    property int horizontal:  0
    property int vertical:    0

    function updateBattery(value) {
        battery = value;
    }

    function updateCompassCalibration(value) {
        compass = value;
    }

    function updateVerticalAccuracy(value) {
        vertical = value;
    }

    function updateHorizontalAccuracy(value) {
        horizontal = value;
    }

    Image {
        source: "level-white.png"
        anchors.fill: parent
    }

    Image {
        source: "secondhand.png"
        width: parent.width
        height: parent.height*0.55
        transform: Rotation {
            origin.x: width/2
            origin.y: height/2
            angle: (battery * 0.7 -35) % 360
            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: .15
                    modulus: 360
                }
            }
        }
    }

    Image {
        source: "secondhand.png"
        width: parent.width
        height: parent.height*0.55
        transform: Rotation {
            origin.x: width/2
            origin.y: height/2
            angle: (compass * 0.7 -125) % 360
            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: .15
                    modulus: 360
                }
            }
        }
    }

    Image {
        source: "secondhand.png"
        width: parent.width
        height: parent.height*0.55
        transform: Rotation {
            origin.x: width/2
            origin.y: height/2
            angle: ((100-vertical) * 0.7 +55) % 360
            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: .15
                    modulus: 360
                }
            }
        }
    }

    Image {
        source: "secondhand.png"
        width: parent.width
        height: parent.height*0.55
        transform: Rotation {
            origin.x: width/2
            origin.y: height/2
            angle: ((100-horizontal) * 0.7 +145) % 360
            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: .15
                    modulus: 360
                }
            }
        }
    }

    Rectangle {
        x: parent.width/4
        y: x
        width: parent.width-2*x
        height: parent.height-2*y
        color: "#e0e0e0"
        radius: parent.width/2
    }
}

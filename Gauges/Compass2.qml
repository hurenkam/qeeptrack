import QtQuick 2.5
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property int mode:        1 // 0: northup; 1: headingup; 2: bearingup
    property double heading:  0
    property double bearing:  0

    onModeChanged:    update()
    onHeadingChanged: update()
    onBearingChanged: update()

    Component.onCompleted: update()

    function updateHeading(value) {
        heading = value;
    }

    function updateBearing(value) {
        bearing = value;
    }

    function updateMode(value) {
        mode = value;
    }

    function update() {
        shield.angle = (mode==0)? 0
                   : ( (mode==1)? 360 - root.heading
                                : 360 - root.bearing )
        needle.angle = (mode==0)? root.heading
                   : ( (mode==1)? 0
                                : 360 - root.bearing + root.heading )
        ring.angle =   (mode==0)? root.bearing
                   : ( (mode==1)? 360 - root.heading + root.bearing
                                : 0 )
    }

    Image {
        source: "compassring.png"
        anchors.fill: parent
        transform: Rotation {
            id: ring
            origin.x: width/2
            origin.y: height/2
            angle: 0
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
        source: "compass.png"
        anchors.fill: parent
        transform: Rotation {
            id: shield
            origin.x: width/2
            origin.y: height/2
            angle: 0
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
        source: "compassneedle.png"
        anchors.fill: parent
        transform: Rotation {
            id: needle
            origin.x: width/2
            origin.y: height/2
            angle: 0
            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: .15
                    modulus: 360
                }
            }
        }
    }
}

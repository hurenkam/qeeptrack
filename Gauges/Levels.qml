import QtQuick 2.5

Item {
    id: root

    property variant layout: Item {}
    x: layout.x; y: layout.y; width: layout.width; height: layout.height

    property int compass:     0
    property int battery:     0
    property int horizontal:  0
    property int vertical:    0

    Image {
        source: "level.png"
        anchors.fill: parent
    }

    Image {
        source: "levelhand.png"
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
        source: "levelhand.png"
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
        source: "levelhand.png"
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
        source: "levelhand.png"
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
}

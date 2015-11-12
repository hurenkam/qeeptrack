import QtQuick 2.5
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string name: "compass"
    property list<QtObject> sources: [
        Item { id: north;   property string name: "North";            property double source: 0 },
        Item { id: heading; property string name: "Current Heading";  property double source: compassmodel.heading },
        Item { id: course;  property string name: "Current Course";   property double source: compassmodel.course },
        Item { id: bearing; property string name: "Current Bearing";  property double source: monitormodel.bearing }
    ]

    property list<QtObject> targets: [
        Item {
            id: dial;
            property string name: "Dial";
            property int mode: 0;
            property double value: up.value + sources[mode].source
        },
        Item {
            id: needle;
            property string name: "Needle";
            property int mode: 1;
            property double value: up.value + sources[mode].source
        },
        Item {
            id: up;
            property string name: "Up";
            property int mode: 1;
            property double value: 360 - sources[mode].source
        },
        Item {
            id: ring;
            property string name: "Ring";
            property int mode: 3;
            property double value: up.value + sources[mode].source
        }
    ]

    property Item optiontabs: TabLayout {
        id: tablayout

        TabItem {
            title: "Dial"
        }
        TabItem {
            title: "Needle"
        }
        TabItem {
            title: "Up"
        }
        TabItem {
            title: "Ring"
        }
    }

    Image {
        source: "compassring.png"
        anchors.fill: parent
        transform: Rotation {
            origin.x: width/2
            origin.y: height/2
            angle: ring.value
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
            origin.x: width/2
            origin.y: height/2
            angle: dial.value
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
            origin.x: width/2
            origin.y: height/2
            angle: needle.value
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

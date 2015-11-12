import QtQuick 2.5
import QtQuick.Window 2.2
import "qrc:/Components"

TabOptionsPage {
    id: root
    showheader: false
    anchors.fill: parent
    property var gauge: null
    property bool landscape: (Screen.width>Screen.height)
    property bool portrait: (Screen.width<=Screen.height)
    property int buttonwidth: portrait? (Screen.width/8): (Screen.height/8)
    property list<QtObject> sources
    property list<QtObject> targets

    tabs: TabLayout {
        id: tablayout
        x:      landscape?                                 root.height+15 : 0
        y:      landscape?                                              0 : root.width+15
        width:  landscape?                      root.width-root.height-15 : root.width
        height: landscape?                                    root.height : root.height-root.width-15

        TabItem {
            title: "Analog"
        }
        TabItem {
            title: "Top"
        }
        TabItem {
            title: "Bottom"
        }
    }

    background: Rectangle {
        id: gauge
        objectName: "gauge"
        anchors.fill: parent
        property double margin: root.landscape? (height-radius)/2 : (width-radius)/2
        property double radius: root.landscape? height*0.9 : width*0.9

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: Qt.darker(activePalette.light)
            }
            GradientStop {
                position:  1.0
                color: Qt.darker(activePalette.dark)
            }
        }

        Item {
            id: gaugecontainer
            x: gauge.margin
            y: gauge.margin
            width: gauge.radius
            height: gauge.radius

            Compass2 {
                anchors.fill: parent
            }
        }

        ToolButton {
            id: leftbutton
            x: 10; y:10
            width: buttonwidth
            height: width

            bgcolor: "black"
            source: "backc.png";
            onClicked: {
                console.log("CompassOptionsPage.onCancel")
                root.cancel();
            }
        }

        ToolButton {
            id: rightbutton

            x: root.width - 10 -width; y:10
            width: buttonwidth
            height: width

            source: "confirmc.png";
            bgcolor: "black"

            onClicked: {
                console.log("CompassOptionsPage.onConfirm")
                optionsChanged()
                pageStack.pop()
            }

        }
    }

    property var gaugeref: null
    onPushed: {
        console.log("CompassOptionsPage.onPushed")
    }
    onPopped: {
        console.log("CompassOptionsPage.onPopped")
    }
}

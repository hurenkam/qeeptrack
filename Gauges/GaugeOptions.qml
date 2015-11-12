import QtQuick 2.5
import QtQuick.Window 2.2
import "qrc:/Components"

TabOptionsPage {
    id: root
    showheader: false
    anchors.fill: parent
    property var gauge
    property var instance
    property int buttonwidth: 50 * screen.scale
    property list<QtObject> sources
    property list<QtObject> targets

    tabs: if (instance) instance.optiontabs
    onTabsChanged: {
        console.log("GaugeOptions.onTabsChanged()")
        tabs.x=      screen.landscape?                       parent.height+15 : 0
        tabs.y=      screen.landscape?                                      0 : parent.width+15
        tabs.width=  screen.landscape?          parent.width-parent.height-15 : parent.width
        tabs.height= screen.landscape?                          parent.height : parent.height-parent.width-15
    }

    background: Rectangle {
        id: background
        objectName: "gauge"
        anchors.fill: parent
        property double margin: screen.landscape? (height-radius)/2 : (width-radius)/2
        property double radius: screen.landscape? height*0.9 : width*0.9

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
            x: background.margin
            y: background.margin
            width: background.radius
            height: background.radius
        }

        ToolButton {
            id: leftbutton
            x: 10; y:10
            width: buttonwidth
            height: width

            bgcolor: "black"
            source: "backc.png";
            onClicked: {
                root.cancel();
            }
        }

        ToolButton {
            id: rightbutton

            x: root.width - 10 -buttonwidth; y:10
            width: buttonwidth
            height: width

            source: "confirmc.png";
            bgcolor: "black"

            onClicked: {
                console.log("GaugeOptions.onConfirm")
                optionsChanged()
                pageStack.pop()
            }

        }
    }

    property var gaugeref: null
    onPushed: {
        console.log("GaugeOptions.onPushed")
        gaugeref = root.gauge.createGauge(gaugecontainer,root.gauge.gaugetype)
    }
    onPopped: {
        console.log("GaugeOptions.onPopped")
        root.gauge.destroyGauge(gaugeref,"clock")
    }
}

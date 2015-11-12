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

    onInstanceChanged: {
        console.log("GaugeOptions.onInstanceChanged: ",instance)
        updateTabs()
     }

    function updateTabs() {
        console.log("GaugeOptions.updateTabs()",instance.sources,instance.targets)
        if (instance.sources) {
            console.log("GaugeOptions.onInstanceChanged() targets:", instance.targets.length, "sources:", instance.sources.length)

            var component = Qt.createComponent("qrc:/Components/TabLayout.qml");
            if (tabs) tabs.destroy()
            tabs = component.createObject(root, { } );
            tabs.x=      screen.landscape?                       parent.height+15 : 0
            tabs.y=      screen.landscape?                                      0 : parent.width+15
            tabs.width=  screen.landscape?          parent.width-parent.height-15 : parent.width
            tabs.height= screen.landscape?                          parent.height : parent.height-parent.width-15
            for (var i=0; i<instance.targets.length; i++)
            {
                var component
                component = Qt.createComponent("qrc:/Components/TabItem.qml");
                var tabitem = component.createObject(tabs, { title: instance.targets[i].name } );

                component = Qt.createComponent("qrc:/Components/OptionList.qml");
                var optionlist = component.createObject(tabitem, { x: 0, y:0, width: parent.width } );

                component = Qt.createComponent("qrc:/Components/RadioBox.qml");
                var radiobox = component.createObject(optionlist, { } );

                for (var j=0; j<instance.sources.length; j++)
                {
                    component = Qt.createComponent("qrc:/Components/OptionRadioButton.qml");
                    var optionradiobutton = component.createObject(radiobox, { text: instance.sources[j].name } );
                    radiobox.append(optionradiobutton)
                }

                optionlist.items = radiobox
                optionlist.clicked.connect(radiobox.updateTicked)
                radiobox.updateTicked(instance.targets[i].mode)
            }
            initTabs()
            layoutTabs()
        }
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

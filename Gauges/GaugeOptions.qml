import QtQuick 2.5
import QtQuick.Window 2.2
import "qrc:/Components"
import "qrc:/Dashboard"

OptionsPage {
    id: root
    color: "#e0e0e0"

    title: ""
    property var gauge
    property var gaugeref
    property var instance
    property Item tabs
    property list<QtObject> sources
    property list<QtObject> targets

    function confirm() {
        console.log("GaugeOptions.onConfirm")
        for (var i=0; i<gaugeref.targets.length; i++)
            instance.targets[i].setMode(gaugeref.targets[i].mode)
        instance.saveSettings()
        pagestack.pop()
    }

    onGaugerefChanged: {
        if (gaugeref) {
            console.log("GaugeOptions.onGaugerefChanged: ",gaugeref, gaugeref.name, gaugeref.targets.length)
            updateTabs()
        }
    }

    Item {
    //Rectangle {
        id: gaugecontainer
        x: 10
        y: 10
        width: screen.portrait? parent.width-20: parent.height-20
        height: width
        //color: "black"
        //radius: width/2
    }

    OptionTabsLayout {
        id: tabslayout
        x: screen.portrait? 0 : gaugecontainer.width
        y: screen.portrait? gaugecontainer.height + 20: 10
        width:  parent.width - x
        height: parent.height -y
        selected: 0
/*
        OptionTab {
            name: "Gauge"

            OptionRadioBox {
                id: mapselectionbox
                title: "Map Type"

                OptionRadioButton {
                    id: mapselection1
                    text: "button1"
                }

                OptionRadioButton {
                    id: mapselection2
                    text: "button2"
                }
            }
        }
*/
    }

    property Item _temp: Item { id: temp }
    function updateTabs() {
        console.log("GaugeOptions.updateTabs()",instance.sources,instance.targets)
        if (instance.sources) {
            for (var i=0; i<gaugeref.targets.length; i++)
            {
                console.log("Adding tab:", gaugeref.targets[i].name)
                var component
                component = Qt.createComponent("qrc:/Components/OptionTab.qml");
                var tabitem = component.createObject(tabslayout, { name: gaugeref.targets[i].name } );

                component = Qt.createComponent("qrc:/Components/OptionRadioBox.qml");
                var radiobox = component.createObject(temp, { } );
                //tabitem._content.push(radiobox)

                for (var j=0; j<gaugeref.sources.length; j++)
                {
                    component = Qt.createComponent("qrc:/Components/OptionRadioButton.qml");
                    var optionradiobutton = component.createObject(temp, { text: gaugeref.sources[j].name } );
                    radiobox.addButton(optionradiobutton)
                }
                gaugeref.targets[i].setMode(instance.targets[i].mode)
                radiobox.updateSelectedButton(gaugeref.targets[i].mode)
                radiobox.selectedButtonUpdated.connect(gaugeref.targets[i].setMode)
                radiobox.layout()
                tabitem.addBox(radiobox)
                tabslayout.addTab(tabitem)
            }
            tabslayout.layout()
        }
    }

    onPushed: {
        console.log("GaugeOptions.onPushed")
        gaugeref = root.gauge.createGauge(gaugecontainer,root.gauge.gaugetype)
    }
    onPopped: {
        console.log("GaugeOptions.onPopped")
        root.gauge.destroyGauge(gaugeref,"clock")
    }
}

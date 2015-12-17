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
        id: gaugecontainer
        x: 10
        y: 10
        width: screen.portrait? parent.width-20: parent.height-20
        height: width
    }

    OptionTabsLayout {
        id: tabslayout
        x: screen.portrait? 0 : gaugecontainer.width + gaugecontainer.x * 2
        y: screen.portrait? gaugecontainer.height + 20: 30
        width:  parent.width - x
        height: parent.height -y
        selected: 0
    }

    property Item _temp: Item { id: temp }
    function updateTabs() {
        console.log("GaugeOptions.updateTabs()",instance.sources,instance.targets)
        if (instance.sources) {
            var sources = instance.sources;

            for (var i=0; i<gaugeref.targets.length; i++)
            {
                console.log("Adding tab:", gaugeref.targets[i].name)
                var component
                component = Qt.createComponent("qrc:/Components/OptionTab.qml");
                var tabitem = component.createObject(tabslayout, { name: gaugeref.targets[i].name } );
                tabslayout.addTab(tabitem)

                component = Qt.createComponent("qrc:/Components/OptionRadioBox.qml");
                var radiobox = component.createObject(temp, { } );
                tabitem.addBox(radiobox)

                for (var j=0; j<sources.length; j++)
                {
                    component = Qt.createComponent("qrc:/Components/OptionRadioButton.qml");
                    var optionradiobutton = component.createObject(temp, { text: sources[j].title } );
                    radiobox.addButton(optionradiobutton)
                }
                gaugeref.targets[i].setMode(instance.targets[i].mode)
                radiobox.updateSelectedButton(gaugeref.targets[i].mode)
                radiobox.selectedButtonUpdated.connect(gaugeref.targets[i].setMode)
                radiobox.layout()
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

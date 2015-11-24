import QtQuick 2.5
import QtPositioning 5.5
import QtLocation 5.5
import QtSensors 5.0
import QtQuick.Window 2.2
import "qrc:/Components"
import "qrc:/Models"
import "qrc:/Gauges"

Item {
    id: root
    property string gaugetype: "clock"
    property string gaugename: ""
    property string gaugeprefix: ""
    property int gaugeindex: -1
    property var gaugeinstance
    property bool started: false
    property var stack: null
    property bool landscape: screen.landscape

    signal clicked(int index)
    signal options(int index)

    onGaugetypeChanged: draw()

    property bool enableanimations: false
    Timer {
        id: timer
        interval: 1500;
        running: true;
        repeat: false;
        onTriggered: {
            root.enableanimations = true
        }
    }

    MouseHandler {
        id: mouseHandler
        anchors.fill: parent
        onSingleTap: root.clicked(gaugeindex)
        onLongTap: {//root.reset(gaugeindex)
            clockmodel.reset()
            speedmodel.reset()
            altitudemodel.reset()
            monitormodel.reset()
            compassmodel.reset()
        }
        onDoubleTap: root.options(gaugeindex)
    }

    Component.onCompleted: {
        started = true
        draw()
    }

    property var optionspage
    onOptions: {
        if (optionspage) optionspage.destroy
        var component = Qt.createComponent("qrc:/Gauges/GaugeOptions.qml");
        var optionspage = component.createObject(parent, { gauge: root, instance: gaugeinstance } );
        stack.push(optionspage)
    }

    function destroyGauge(gauge,gaugetype) {
        gauge.destroy()
    }

    function createGauge(parent,gaugetype) {
        var result = null
        switch (gaugetype) {
            case "clock": {
                var component = Qt.createComponent("qrc:/Gauges/Clock.qml");
                result = component.createObject(parent, { prefix: "qeeptrack.clock." } );
                break;
            }

            case "compass": {
                var component = Qt.createComponent("qrc:/Gauges/Compass2.qml");
                result =  component.createObject(parent, { prefix: "qeeptrack.compass." } );
                break;
            }

            case "altimeter": {
                var component = Qt.createComponent("qrc:/Gauges/Altimeter.qml");
                result = component.createObject(parent, { prefix: "qeeptrack.altimeter." } );
                break;
            }

            case "distance": {
                var component = Qt.createComponent("qrc:/Gauges/Distancemeter.qml");
                result = component.createObject(parent, { prefix: "qeeptrack.distance." } );
                break;
            }

            case "speedometer": {
                var component = Qt.createComponent("qrc:/Gauges/Speedometer.qml");
                result = component.createObject(parent, { prefix: "qeeptrack.speedometer." } );
                break;
            }

            case "levels": {
                var component = Qt.createComponent("qrc:/Gauges/Levels.qml");
                result = component.createObject(parent, { prefix: "qeeptrack.levels." } );
                break;
            }

            case "satellites": {
                var component = Qt.createComponent("qrc:/Gauges/Satellites.qml");
                result = component.createObject(parent, { prefix: "qeeptrack.satellites." } );
                break;
            }
        }
        return result
    }

    function draw() {
        if ( (!started)
          || (clockmodel == null)
          || (monitormodel==null)
          || (compassmodel==null)
          || (altitudemodel==null)
          || (speedmodel==null) )
            return

        if (gaugeinstance) gaugeinstance.destroy()
        gaugeinstance = createGauge(root,gaugetype)
    }
}

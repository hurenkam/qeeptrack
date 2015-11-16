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
    property string gaugename: "localtime"
    property int gaugeindex: -1
    property var gaugeinstance
    property bool started: false
    property bool testmode: false
    property var stack: null
    property bool landscape: screen.landscape

    signal clicked(int index)
    signal options(int index)
    signal reset(int index)

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

    PositionSource {
        id: positionsource
        updateInterval: 250
        active: true
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods

        Component.onCompleted: {
            positionsource.start()
            positionsource.update()
        }
    }

    OrientationSensor {
        id: orientationsensor

        Component.onCompleted: {
            orientationsensor.start()
        }
    }

    Compass {
        id: compasssensor
        dataRate: 1
        active: true

        Component.onCompleted: {
            compasssensor.start()
        }
    }

    ClockModel {
        id: clockmodel
        //enableanimations: root.enableanimations
    }

    SpeedModel {
        id: speedmodel;
        position: positionsource.position
        enableanimations: root.enableanimations
        testmode: root.testmode
    }

    AltitudeModel {
        id: altitudemodel;
        position: positionsource.position
        enableanimations: root.enableanimations
        testmode: root.testmode
    }

    MonitorModel {
        id: monitormodel;
        position: positionsource.position
        elapsedtime: clockmodel.elapsed
        enableanimations: root.enableanimations
    }

    CompassModel
    {
        id: compassmodel;
        position: positionsource.position;
        compass: compasssensor.reading;
        orientation: orientationsensor.reading
        //enableanimations: root.enableanimations
        testmode: root.testmode
    }

    MouseHandler {
        id: mouseHandler
        anchors.fill: parent
        onSingleTap: root.clicked(gaugeindex)
        onLongTap: root.reset(gaugeindex)
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
                result = component.createObject(parent, { } );
                break;
            }

            case "compass": {
                var component = Qt.createComponent("qrc:/Gauges/Compass2.qml");
                result =  component.createObject(parent, { } );
                break;
            }

            case "altimeter": {
                var component = Qt.createComponent("qrc:/Gauges/Altimeter.qml");
                result = component.createObject(parent, { } );
                break;
            }

            case "distance": {
                var component = Qt.createComponent("qrc:/Gauges/Distancemeter.qml");
                result = component.createObject(parent, { } );
                break;
            }

            case "speedometer": {
                var component = Qt.createComponent("qrc:/Gauges/Speedometer.qml");
                result = component.createObject(parent, { } );
                break;
            }

            case "levels": {
                var component = Qt.createComponent("qrc:/Gauges/Levels.qml");
                result = component.createObject(parent, { } );
                break;
            }

            case "satellites": {
                var component = Qt.createComponent("qrc:/Gauges/Satellites.qml");
                result = component.createObject(parent, { } );
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

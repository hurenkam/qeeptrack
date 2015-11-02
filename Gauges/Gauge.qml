import QtQuick 2.5
import QtPositioning 5.5
import QtLocation 5.5
import QtSensors 5.0
import "qrc:/Components"
import "qrc:/Models"

Item {
    id: root
    property string gaugetype: "clock"
    property string gaugename: "localtime"
    property int gaugeindex: -1
    property var gaugeinstance: null
    property bool started: false

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
    }

    AltitudeModel {
        id: altitudemodel;
        position: positionsource.position
        enableanimations: root.enableanimations
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

    function draw() {
        if ( (!started)
          || (clockmodel == null)
          || (monitormodel==null)
          || (compassmodel==null)
          || (altitudemodel==null)
          || (speedmodel==null) )
            return

        if (gaugeinstance != null)
            gaugeinstance.destroy()

        switch (gaugetype) {
            case "clock": {
                var component = Qt.createComponent("qrc:/Gauges/Clock.qml");
                var clock = component.createObject(gaugeitem, { "name": gaugename } );
                clockmodel.timeUpdate.connect(clock.updateCurrent)
                clockmodel.elapsedUpdate.connect(clock.updateElapsed)
                monitormodel.remainingTimeUpdate.connect(clock.updateMonitor)
                gaugeinstance = clock
                break;
            }

            case "compass": {
                var component = Qt.createComponent("qrc:/Gauges/Compass2.qml");
                var compass = component.createObject(gaugeitem, { } );
                compassmodel.headingUpdate.connect(compass.updateHeading)
                gaugeinstance = compass
                break;
            }

            case "altimeter": {
                var component = Qt.createComponent("qrc:/Gauges/Altimeter.qml");
                var altimeter = component.createObject(gaugeitem, { "name": "altimeter (100m)", "divider":100, "digits":2 } );
                altitudemodel.currentUpdate.connect(altimeter.updateCurrent)
                altitudemodel.minimumUpdate.connect(altimeter.updateMinimum)
                altitudemodel.maximumUpdate.connect(altimeter.updateMaximum)
                gaugeinstance = altimeter
                break;
            }

            case "distance": {
                var component = Qt.createComponent("qrc:/Gauges/Altimeter.qml");
                var meter = component.createObject(gaugeitem, { "name": "distance (km)", "divider":1000, "digits":1 } );
                monitormodel.distanceUpdate.connect(meter.updateCurrent)
                monitormodel.distanceUpdate.connect(meter.updateMaximum)
                monitormodel.remainingDistanceUpdate.connect(meter.updateMinimum)
                gaugeinstance = meter
                break;
            }

            case "speedometer": {
                var component = Qt.createComponent("qrc:/Gauges/Speedometer.qml");
                var speedometer = component.createObject(gaugeitem, { "name": gaugename } );
                speedmodel.currentUpdate.connect(speedometer.updateCurrent)
                monitormodel.averageSpeedUpdate.connect(speedometer.updateAverage)
                speedmodel.minimumUpdate.connect(speedometer.updateMinimum)
                speedmodel.maximumUpdate.connect(speedometer.updateMaximum)
                monitormodel.remainingDistanceUpdate.connect(speedometer.updateMonitor)
                gaugeinstance = speedometer
                break;
            }

            case "levels": {
                var component = Qt.createComponent("qrc:/Gauges/Levels.qml");
                var levels = component.createObject(gaugeitem, { } );
                compassmodel.calibrationUpdate.connect(levels.updateCompassCalibration)
                //positionsource.verticalAccuracyChanged.connect(levels.updateVerticalAccuracy)
                //positionsource.horizontalAccuracyChanged.connect(levels.updateHorizontalAccuracy)
                gaugeinstance = levels
                break;
            }

            case "satellites": {
                var component = Qt.createComponent("qrc:/Gauges/Satellites.qml");
                var satellites = component.createObject(gaugeitem, { } );
                gaugeinstance = satellites
                break;
            }
        }
    }
}


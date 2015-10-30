import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtPositioning 5.5
import QtLocation 5.5
import QtSensors 5.0
import Local 1.0
import "qrc:/Dashboard"
import "qrc:/Gauges"
import "qrc:/Models"

Rectangle {
    id: root
    anchors.fill: parent
    color: "black"

    PositionSource {
        id: positionsource
        updateInterval: 1000
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
    }

    SpeedModel {
        id: speedmodel;
        position: positionsource.position
    }

    AltitudeModel {
        id: altitudemodel;
        position: positionsource.position
    }

    MonitorModel {
        id: monitormodel;
        position: positionsource.position
    }

    CompassModel
    {
        id: compassmodel;
        position: positionsource.position;
        compass: compasssensor.reading;
        orientation: orientationsensor.reading
    }

    DashboardLayout {
        id: layout;
        mode: (root.height>root.width)? 0: 1
    }

    ListModel {
        id: gaugemodel
        ListElement { index: 0; gauge: "clock";       name: "time" }
        ListElement { index: 1; gauge: "compass";     name: "compass" }
        ListElement { index: 2; gauge: "speedometer"; name: "speed" }
        ListElement { index: 3; gauge: "altimeter";   name: "altitude" }
        ListElement { index: 4; gauge: "levels";      }
        ListElement { index: 5; gauge: "satellites";  }
    }

    Repeater {
        anchors.fill: parent
        model: gaugemodel
        delegate: gaugedelegate
    }

    property list<QtObject> gauges: [
        Item {},
        Item {},
        Item {},
        Item {},
        Item {},
        Item {}
    ]

    Component {
        id: gaugedelegate

        Item {
            id: gaugeitem
            x: layout.current[index].x
            y: layout.current[index].y
            width: layout.current[index].width
            height: layout.current[index].height
            property string gaugetype: gauge
            property int gaugeindex: index

            Component.onCompleted: {
                switch (gauge) {
                    case "clock": {
                        var component = Qt.createComponent("qrc:/Gauges/Clock.qml");
                        var clock = component.createObject(gaugeitem, { } );
                        clockmodel.timeUpdate.connect(clock.updateCurrent)
                        clockmodel.elapsedUpdate.connect(clock.updateElapsed)
                        monitormodel.remainingTimeChanged.connect(clock.updateMonitor)
                        gauges[index] = clock
                        break;
                    }

                    case "compass": {
                        var component = Qt.createComponent("qrc:/Gauges/Compass2.qml");
                        var compass = component.createObject(gaugeitem, { } );
                        compassmodel.headingUpdate.connect(compass.updateHeading)
                        gauges[index] = compass
                        break;
                    }

                    case "altimeter": {
                        var component = Qt.createComponent("qrc:/Gauges/Altimeter.qml");
                        var altimeter = component.createObject(gaugeitem, { } );
                        altitudemodel.currentUpdate.connect(altimeter.updateCurrent)
                        altitudemodel.averageUpdate.connect(altimeter.updateAverage)
                        altitudemodel.minimumUpdate.connect(altimeter.updateMinimum)
                        altitudemodel.maximumUpdate.connect(altimeter.updateMaximum)
                        gauges[index] = altimeter
                        break;
                    }

                    case "speedometer": {
                        var component = Qt.createComponent("qrc:/Gauges/Speedometer.qml");
                        var speedometer = component.createObject(gaugeitem, { } );
                        speedmodel.currentUpdate.connect(speedometer.updateCurrent)
                        speedmodel.averageUpdate.connect(speedometer.updateAverage)
                        speedmodel.minimumUpdate.connect(speedometer.updateMinimum)
                        speedmodel.maximumUpdate.connect(speedometer.updateMaximum)
                        monitormodel.remainingDistanceChanged.connect(speedometer.updateMonitor)
                        gauges[index] = speedometer
                        break;
                    }

                    case "levels": {
                        var component = Qt.createComponent("qrc:/Gauges/Levels.qml");
                        var levels = component.createObject(gaugeitem, { } );
                        compassmodel.calibrationUpdate.connect(levels.updateCompassCalibration)
                        //positionsource.verticalAccuracyChanged.connect(levels.updateVerticalAccuracy)
                        //positionsource.horizontalAccuracyChanged.connect(levels.updateHorizontalAccuracy)
                        gauges[index] = levels
                        break;
                    }

                    case "satellites": {
                        var component = Qt.createComponent("qrc:/Gauges/Satellites.qml");
                        var satellites = component.createObject(gaugeitem, { } );
                        gauges[index] = satellites
                        break;
                    }
                }
            }
        }
    }
}

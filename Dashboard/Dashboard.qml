import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtPositioning 5.5
import QtLocation 5.5
import QtSensors 5.0
import Local 1.0
import "qrc:/Dashboard"
import "qrc:/Gauges"

Rectangle {
    id: root
    anchors.fill: parent
    color: "black"

    property int clockindex:       0
    property int compassindex:     1
    property int speedometerindex: 2
    property int altimeterindex:   3
    property int levelsindex:      4
    property int satellitesindex:  5

    DashboardLayout {
        id: layout;
        mode: (root.height>root.width)? 0: 1
    }

    Timer {
        id: timer
        interval: 1000;
        running: true;
        repeat: true;
        property date currenttime: new Date()

        onTriggered: {            
            currenttime = new Date()
        }
    }

    OrientationSensor {
        id: orientationsensor
        property int rotation: 0

        Component.onCompleted: {
            orientationsensor.start()
        }

        onReadingChanged: {
            switch (orientationsensor.reading.orientation) {
                case OrientationReading.LeftUp:   rotation = 270; break;
                case OrientationReading.TopDown:  rotation = 180; break;
                case OrientationReading.RightUp:  rotation =  90; break;
                default: rotation = 0; break;
            }
        }
    }

    Compass {
        id: compasssensor
        dataRate: 1
        active: true

        // Note: The orientation correction seems to be needed on iPhone 6s, but not on HTC Evo 3D.
        //       How to solve this properly?
        property int azimuth: (reading == null)? 0 : reading.azimuth + orientationsensor.rotation

        Component.onCompleted: {
            compasssensor.start()
        }
    }

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

    Altimeter {
        id:      altimeter
        layout:  layout.current[altimeterindex]
        current: ((positionsource.position == null) || (!positionsource.position.altitudeValid))? 0
                 : positionsource.position.coordinate.altitude
    }

    Speedometer {
        id:      speedometer
        layout:  layout.current[speedometerindex]
        current: ((positionsource.position == null) || (!positionsource.position.speedValid))? 0
                 : positionsource.position.speed * 3.6
    }

    Compass2 {
        id:      compass
        layout:  layout.current[compassindex]
        heading: compasssensor.azimuth
    }

    Clock {
        id:      clock
        layout:  layout.current[clockindex]
        current: timer.currenttime
    }

    Levels {
        id:         levels
        layout:     layout.current[levelsindex]
        compass:    (compasssensor.reading == null)? 0
                    : compasssensor.reading.calibrationLevel * 100
        vertical:   ((!positionsource.verticalAccuracyValid) || (positionsource.verticalAccuracy > 300))? 0
                    : positionsource.verticalAccuracy/3
        horizontal: ((!positionsource.horizontalAccuracyValid) || (positionsource.horizontalAccuracy > 300))? 0
                    : positionsource.horizontalAccuracy/3
    }

    Satellites {
        id: satellites
        layout: layout.current[satellitesindex]

        // Note: On IOS there seems to be no satellite data source available, but this should work fine on Android
        satellitemodel: SatelliteModel {
            id: satellitemodel
            singleRequestMode: false
            running: true
        }
    }
}

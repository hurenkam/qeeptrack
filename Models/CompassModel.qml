import QtQuick 2.0
import QtSensors 5.0

Item {
    id: root

    property var position: null
    property var compass: null
    property var orientation: null

    signal courseUpdate(double value)
    signal headingUpdate(double value)
    signal calibrationUpdate(double value)

    onPositionChanged: update()
    onCompassChanged: update()
    onOrientationChanged: update()

    function update() {
        var rotation = 0
        if (orientation != null)
        {
            // Note: The orientation correction seems to be needed on iPhone 6s, but not on HTC Evo 3D.
            //       How to solve this properly?
            switch (orientation.orientation) {
                case OrientationReading.LeftUp:   rotation = 270; break;
                case OrientationReading.TopDown:  rotation = 180; break;
                case OrientationReading.RightUp:  rotation =  90; break;
                default: rotation = 0; break;
            }
        }

        if (compass != null)
        {
            headingUpdate(compass.azimuth + rotation)
            calibrationUpdate(compass.calibrationLevel * 100)
        }

        if (position != null)
        {
            if (position.courseValid)
                courseUpdate(position.course)
        }
    }
}


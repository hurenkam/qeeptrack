import QtQuick 2.0
import QtSensors 5.0

Item {
    id: root

    property var position: null
    property var compass: null
    property var orientation: null

    property bool enableanimations: true

    property double course: 0
    Behavior on course {
        id: courseanimation
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    property double heading: 0
    Behavior on heading {
        id: headinganimation
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    property double calibration: 0
    Behavior on calibration {
        id: calibrationanimation
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    property bool testmode: false

    onPositionChanged:    if (!testmode) update()
    onCompassChanged:     if (!testmode) update()
    onOrientationChanged: if (!testmode) update()

    Timer {
        id: timer
        interval: 100;
        running: testmode;
        repeat: true;

        property double dcal: 0.002
        property double dhead: 0.5

        onTriggered: {
            if (heading > 90)
                dhead = -0.5
            if (heading < -90)
                dhead = 0.5
            heading += dhead

            if (calibration > 0.9)
                dcal = -0.002
            if (calibration < 0.4)
                dcal = 0.002
            calibration += dcal

            course = heading + calibration * 5
        }
    }

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
            heading = compass.azimuth + rotation
            calibration = compass.calibrationLevel * 100
        }

        if (position != null)
        {
            if (position.courseValid)
                course = position.course
        }
    }
}

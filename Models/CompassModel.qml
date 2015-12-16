import QtQuick 2.0
import QtSensors 5.0

Item {
    id: root

    property var position: null
    property var compass: null
    property var orientation: null

    property bool enableanimations: true

    property list<QtObject> availablesources: [
        RotationSource { id: course;      title: "Course";      name: "course";      units: "degrees" },
        RotationSource { id: heading;     title: "Heading";     name: "heading";     units: "degrees" },
        DoubleSource   { id: calibration; title: "Calibration"; name: "calibration"; units: "fraction" }
    ]

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
            if (heading.value > 90)
                dhead = -0.5
            if (heading.value < -90)
                dhead = 0.5
            heading.value += dhead

            if (calibration.value > 0.9)
                dcal = -0.002
            if (calibration.value < 0.4)
                dcal = 0.002
            calibration.value += dcal

            course.value = heading.value + calibration.value * 5
        }
    }

    function reset() {
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
            heading.value = compass.azimuth + rotation
            calibration.value = compass.calibrationLevel * 100
        }

        if (position != null)
        {
            if (position.courseValid)
                course.value = position.course
        }
    }
}

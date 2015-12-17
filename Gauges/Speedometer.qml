import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Base {
    id: root
    anchors.fill: parent

    prefix: "qeeptrack.speedometer."
    name:                  "speed (km/h)"
    dialimagesource:       "qrc:/Gauges/gauge-numbers10-black.png"
    shorthandimagesource:  "speedneedle.png"
    shorthanddivider: 10
    divider: 1
    digits: 0

    onAnalogvalueChanged: {
        if (analogvalue>10) {
            dialimagesource = "qrc:/Gauges/gauge-numbers200-black.png"
            shorthanddivider = 200
        }
    }
}

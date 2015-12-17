import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Base {
    id: root
    anchors.fill: parent

    prefix: "qeeptrack.altimeter."
    name:                  "altitude (100m)"
    dialimagesource:       "qrc:/Gauges/gauge-numbers10-black.png"
    shorthandimagesource:  "shorthand.png"
    longhandimagesource:   "longhand.png"
    secondhandimagesource: "secondhand.png"
    divider: 100
    digits: 2
}

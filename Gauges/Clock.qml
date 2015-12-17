import QtQuick 2.5
import QtQuick.Window 2.2
import "qrc:/Components"

Base {
    id: root
    anchors.fill: parent

    prefix:                "qeeptrack.clock."
    name:                  "clock"
    dialimagesource:       "qrc:/Gauges/clock-numbers-black.png"
    shorthandimagesource:  "shorthand.png"
    longhandimagesource:   "longhand.png"
    secondhandimagesource: "secondhand.png"
    property bool enableanimations: true

    shortangle:   analogvalue.getHours()*360/12 + analogvalue.getMinutes()/2
    longangle:    analogvalue.getMinutes()*360/60 + analogvalue.getSeconds()/10
    secondangle:  analogvalue.getSeconds()*360/60

    topstring:    Qt.formatDateTime(topvalue,"hh:mm:ss");
    bottomstring: Qt.formatDateTime(bottomvalue,"hh:mm:ss");

    Behavior on secondangle {
        id: secondhandanimation
        enabled: root.enableanimations
        SpringAnimation {
            velocity: 6
            modulus: 360
        }
    }
}

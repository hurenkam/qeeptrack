import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Base {
    id: root
    anchors.fill: parent

    prefix: "qeeptrack.speedometer."
    name:                  "speed (km/h)"
    dialimagesource:       ((analogvalue>10) || (maximum.source>10))? "qrc:/Gauges/gauge-numbers200-black.png" : "qrc:/Gauges/gauge-numbers10-black.png"
    shorthandimagesource:  "speedneedle.png"
    divider: 1
    digits: 0

    sources: [
        Item { id: current; property string name: "Current Speed";  property double source: speedmodel.availablesources[0].value },
        Item { id: average; property string name: "Average Speed";  property double source: monitormodel.availablesources[6].value },
        Item { id: minimum; property string name: "Minimum Speed";  property double source: speedmodel.availablesources[1].value },
        Item { id: maximum; property string name: "Maximum Speed";  property double source: speedmodel.availablesources[2].value }
    ]
}

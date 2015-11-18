import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Base {
    id: root
    anchors.fill: parent

    prefix: "qeeptrack.speedometer."
    name:                  "speed (km/h)"
    dialimagesource:       ((analogvalue>10) || (maximum.source>10))? "speed200.png" : "speed10.png"
    shorthandimagesource:  "speedneedle.png"
    divider: 1
    digits: 0

    sources: [
        Item { id: current; property string name: "Current Speed";  property double source: speedmodel.current },
        Item { id: average; property string name: "Average Speed";  property double source: monitormodel.averageSpeed },
        Item { id: minimum; property string name: "Minimum Speed";  property double source: speedmodel.minimum },
        Item { id: maximum; property string name: "Maximum Speed";  property double source: speedmodel.maximum }
    ]
}

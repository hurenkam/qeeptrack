import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Base {
    id: root
    anchors.fill: parent

    prefix: "qeeptrack.distancemeter."
    name: "distance (km)"
    dialimagesource: "speed10.png"
    shorthandimagesource: "shorthand.png"
    longhandimagesource: "longhand.png"
    secondhandimagesource: "secondhand.png"
    divider: 1000
    digits: 1

    sources: [
        Item { property string name: "Trip Distance";       property double source: monitormodel.tripDistance },
        Item { property string name: "Total Distance";      property double source: monitormodel.totalDistance },
        Item { property string name: "Remaining Distance";  property double source: monitormodel.remainingDistance }
    ]
}

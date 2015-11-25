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

    sources: [
        Item { property string name: "Current Altitude";  property double source: altitudemodel.current },
        Item { property string name: "Average Altitude";  property double source: altitudemodel.average },
        Item { property string name: "Minimum Altitude";  property double source: altitudemodel.minimum },
        Item { property string name: "Maximum Altitude";  property double source: altitudemodel.maximum },
        Item { property string name: "Total Ascent";      property double source: altitudemodel.ascent  },
        Item { property string name: "Total Descent";     property double source: altitudemodel.descent }
    ]
}

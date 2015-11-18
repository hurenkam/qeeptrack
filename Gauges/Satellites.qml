import QtQuick 2.5
import Local 1.0
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string prefix: ""
    property variant satellitemodel: null

    Image {
        id: background
        source: "satview.png"
        anchors.fill: parent
    }

    Repeater {
        id: positions
        model: satellitemodel
        delegate: satellites
    }

    Component {
        id: satellites
        Rectangle {
            color: isInUse? "#00ff00" : Qt.rgba(1,signalStrength/32.0,0,1)
            width: root.width/20
            height: root.height/20
            radius: root.width/40
            anchors.centerIn: parent

            transform: [
                Translate {
                    y: elevation * root.height / 180.0
                },
                Rotation {
                    origin.x: width/2
                    origin.y: height/2
                    angle: azimuth - 180
                }
            ]

        }
    }
}

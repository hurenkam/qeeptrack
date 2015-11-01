import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtPositioning 5.5
import QtLocation 5.5
import QtSensors 5.0
import Local 1.0
import "qrc:/Dashboard"
import "qrc:/Gauges"

Rectangle {
    id: root
    anchors.fill: parent
    color: "black"

    property var gauges: []

    function zoomGauge(index)
    {
        var currentzoomed
        var newzoomed

        for (var i=0; i<6; i++) {
            if (gauges[i].gaugeindex==2)
                currentzoomed = i
            if (gauges[i].gaugeindex==index)
                newzoomed = i
        }

        gauges[currentzoomed].gaugeindex = gauges[newzoomed].gaugeindex
        gauges[newzoomed].gaugeindex = 2
    }

    ListModel {
        id: gaugemodel
        ListElement { index: 0; gauge: "clock";       name: "time"; }
        ListElement { index: 1; gauge: "compass";     name: "compass" }
        ListElement { index: 2; gauge: "speedometer"; name: "speed (km/h)" }
        ListElement { index: 3; gauge: "altimeter";   name: "altitude (km)" }
        ListElement { index: 4; gauge: "levels";      name: "levels" }
        ListElement { index: 5; gauge: "distance";    name: "distance (km)" }
    }

    Repeater {
        id: repeater
        anchors.fill: parent
        model: gaugemodel
        delegate: gaugedelegate
    }

    DashboardLayout {
        id: layout;
        mode: (root.height>root.width)? 0: 1
    }

    Component {
        id: gaugedelegate

        Gauge {
            id: gaugeitem
            x: layout.current[gaugeindex].x
            y: layout.current[gaugeindex].y
            width: layout.current[gaugeindex].width
            height: layout.current[gaugeindex].height
            gaugetype: gauge
            gaugeindex: index
            gaugename: name

            onClicked: root.zoomGauge(gaugeindex)

            Component.onCompleted: gauges.push(gaugeitem)
        }
    }
}

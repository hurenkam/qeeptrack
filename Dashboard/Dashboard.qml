import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtPositioning 5.5
import QtLocation 5.5
import QtSensors 5.0
import Local 1.0
import "qrc:/Dashboard"
import "qrc:/Gauges"
import "qrc:/Components"

Page {
    id: root
    anchors.fill: parent
    color: "#e0e0e0"
    onPushed: console.log("Dashboard.onPushed")
    onPopped: console.log("Dashboard.onPopped")

    property var stack: null
    property var gauges: []

    property string prefix: "qeeptrack.dashboard."
    function saveSettings() {
        settings.setValue("gauge0.index",gauges[0].gaugeindex)
        settings.setValue("gauge1.index",gauges[1].gaugeindex)
        settings.setValue("gauge2.index",gauges[2].gaugeindex)
        settings.setValue("gauge3.index",gauges[3].gaugeindex)
        settings.setValue("gauge4.index",gauges[4].gaugeindex)
        settings.setValue("gauge5.index",gauges[5].gaugeindex)
    }

    function loadSettings() {
        gauges[0].gaugeindex = settings.getValue("gauge0.index","0")
        gauges[1].gaugeindex = settings.getValue("gauge1.index","1")
        gauges[2].gaugeindex = settings.getValue("gauge2.index","2")
        gauges[3].gaugeindex = settings.getValue("gauge3.index","3")
        gauges[4].gaugeindex = settings.getValue("gauge4.index","4")
        gauges[5].gaugeindex = settings.getValue("gauge5.index","5")
    }

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

        if (currentzoomed === newzoomed)
        {
            stack.pop()
            return
        }

        gauges[currentzoomed].gaugeindex = gauges[newzoomed].gaugeindex
        gauges[newzoomed].gaugeindex = 2

        saveSettings()
    }

    SettingsDatabase {
        id: settings
        filename: "qeeptrack"
        prefix: root.prefix

        Component.onCompleted: root.loadSettings()
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

    property list<Item> layouts: [
        DashboardLayout1x1   { },
        DashboardLayout4x3   { },
        DashboardLayout3x2   { },
        DashboardLayout16x10 { },
        DashboardLayout16x9  { },
        DashboardLayout21x9  { }
    ]

    Component {
        id: gaugedelegate

        Gauge {
            id: gaugeitem
            x: layouts[screen.mode].current[gaugeindex].x
            y: layouts[screen.mode].current[gaugeindex].y
            width: layouts[screen.mode].current[gaugeindex].width
            height: layouts[screen.mode].current[gaugeindex].height

            Behavior on x {
                PropertyAnimation {
                    target: gaugeitem
                    properties: "x,y,width,height"
                    duration: 200
                }
            }

            Behavior on y {
                PropertyAnimation {
                    target: gaugeitem
                    properties: "x,y,width,height"
                    duration: 200
                }
            }

            Behavior on width {
                PropertyAnimation {
                    target: gaugeitem
                    properties: "x,y,width,height"
                    duration: 200
                }
            }

            Behavior on height {
                PropertyAnimation {
                    target: gaugeitem
                    properties: "x,y,width,height"
                    duration: 200
                }
            }

            gaugetype: gauge
            gaugeindex: index
            gaugename: name
            stack: root.stack

            onClicked: root.zoomGauge(gaugeindex)

            Component.onCompleted: {
                console.log("Dashboard.Gauge.onCompleted()",screen.mode,layouts[screen.mode].current[gaugeindex].x,layouts[screen.mode].current[gaugeindex].y,layouts[screen.mode].current[gaugeindex].width,layouts[screen.mode].current[gaugeindex].height)
                gauges.push(gaugeitem)
            }
        }
    }

    ToolButton {
        id: back

        x: 0
        y: 0
        width: screen.buttonwidth
        height: width

        source: "qrc:/Components/backc.png";
        bgcolor: "black"

        onClicked: {
            console.log("Dashboard.Back")
            stack.pop()
        }
    }
}

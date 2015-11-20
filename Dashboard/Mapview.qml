import QtQuick 2.5
import QtPositioning 5.5
import QtLocation 5.5
import QtSensors 5.0
import QtQuick.Layouts 1.2
import Proj4 1.0
import "qrc:/Components"
import "qrc:/Models"

Page {
    id: root
    anchors.fill: parent
    onPushed: console.log("Mapview.onPushed")
    onPopped: console.log("Mapview.onPopped")

    signal quit()

    property bool init: false
    property var stack: null
    property bool followme: true
    property int buttonwidth: 50 * screen.scale

    PositionSource {
        id: positionsource
        updateInterval: 250
        active: true
        property var current: QtPositioning.coordinate(51.43930725,5.47577798)
        preferredPositioningMethods: PositionSource.SatellitePositioningMethods

        onPositionChanged: {
            if (positionsource.position) {
                if (map.followcurrent)
                    map.center = positionsource.position.coordinate
                else
                    map.followcurrent = false

                current = positionsource.position.coordinate

                if (!init) {
                    console.log ("setting waypoint to current location")
                    monitormodel.waypoint = QtPositioning.coordinate(current.latitude,current.longitude)
                    inittimer.running = true
                }
            }
        }

        Component.onCompleted: {
            positionsource.start()
            positionsource.update()
        }
    }

    property bool testmode: false
    property bool enableanimations: false
    OrientationSensor {
        id: orientationsensor

        Component.onCompleted: {
            orientationsensor.start()
        }
    }

    Compass {
        id: compasssensor
        dataRate: 1
        active: true

        Component.onCompleted: {
            compasssensor.start()
        }
    }

    ClockModel {
        id: clockmodel
        //enableanimations: root.enableanimations
    }

    SpeedModel {
        id: speedmodel;
        position: positionsource.position
        enableanimations: root.enableanimations
        testmode: root.testmode
    }

    AltitudeModel {
        id: altitudemodel;
        position: positionsource.position
        enableanimations: root.enableanimations
        testmode: root.testmode
    }

    MonitorModel {
        id: monitormodel;
        position: positionsource.position
        elapsedtime: clockmodel.elapsed
        enableanimations: root.enableanimations

        Component.onCompleted: waypoint=positionsource.current
    }

    CompassModel
    {
        id: compassmodel;
        position: positionsource.position;
        compass: compasssensor.reading;
        orientation: orientationsensor.reading
        //enableanimations: root.enableanimations
        testmode: root.testmode
    }

    Dashboard {
        id: dashboard
        stack: root.stack
    }

    Timer {
        id: inittimer
        running: false
        repeat: false
        interval: 100
        onTriggered: init=true
    }

    Map {
        id: map
        //anchors.fill: parent
        anchors.left: parent.left
        anchors.right: parent.right
        y: parent.y - buttonwidth -10
        height: parent.height + 2*buttonwidth +20
        zoomLevel: maximumZoomLevel - 2
        property bool followcurrent: true
        center: QtPositioning.coordinate(51.43930725,5.47577798)
        onCenterChanged: if (center !== positionsource.current) followcurrent = false

        plugin: Plugin {
            id: plugin
            name:"osm"
        }

        MouseArea {
            anchors.fill: parent
            onPressAndHold: map.followcurrent=false
        }

        MapQuickItem {
            id: markcenterposition
            anchorPoint.x: currentimage.width/2
            anchorPoint.y: currentimage.height/2
            coordinate: map.center
            zoomLevel: 0.0

            sourceItem: Image {
                id: locator
                source: iscurrent? "qrc:/Components/locator_green.png" : "qrc:/Components/locator_red.png"
                property bool iscurrent: (map.followcurrent && positionsource.current)
                width: buttonwidth
                height: width

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        map.followcurrent = true
                        map.center = positionsource.current
                    }
                }
            }
        }

        MapQuickItem {
            id: markcurrentposition
            anchorPoint.x: currentimage.width/2
            anchorPoint.y: currentimage.height/2
            coordinate: positionsource.current
            visible: (!map.followcurrent && positionsource.current)
            zoomLevel: 0.0

            sourceItem: Image {
                id: currentimage
                source: "qrc:/Components/locator_green.png"
                width: buttonwidth
                height: width
            }
        }

        MapQuickItem {
            id: markwaypoint
            anchorPoint.x: 13
            anchorPoint.y: 48
            coordinate: monitormodel.waypoint
            visible: (monitormodel.waypoint)
            zoomLevel: 0.0

            sourceItem: Image {
                id: waypointimage
                source: "qrc:/Components/flag-plain.png"
                width: 48
                height: width
            }
        }

        Component.onCompleted: {
            for (var i=0; i<supportedMapTypes.length; i++) {
                console.log("supports map type:",supportedMapTypes[i].description)
                //if (supportedMapTypes[i].style===MapType.CycleMap)
                if (supportedMapTypes[i].style===MapType.TerrainMap)
                    activeMapType = supportedMapTypes[i]
            }
        }
    }

    property var datum: Projection {
        coordinate: map.center
        title: "RD"
        xname: "X:"
        yname: "Y:"
        definition: "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.04,49.91,465.84,-1.9848,1.7439,-9.0587,4.0772 +units=m +no_defs"
        property int digits: 0
    }
/*
    property var datum: Projection {
        id: datum
        coordinate: map.center
        title: "WGS84"
        xname: "Lon:"
        yname: "Lat:"
        definition: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
        property int digits: 8
    }
*/
    Rectangle {
        id: infobox
        x: 10
        y: root.height - height - 10
        width: 3*buttonwidth+20
        height: buttonwidth*2 + 10
        color: "white"
        border.color: "black"
        opacity: 0.5
        radius: 20

        GridLayout {
            x: 15
            y: 15
            width: parent.width-30
            height: parent.height-30
            columns: 2
            rows: 4

            Text {
                text: datum.title
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize
                style: Text.Raised; styleColor: "white"
                Layout.columnSpan: 2
            }
            Text {
                text: datum.xname
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: datum.x.toFixed(datum.digits).toString()
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: datum.yname
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: datum.y.toFixed(datum.digits).toString()
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: "Dist:"
                color: "black"
                visible: (distancedisplay.distance !== 0)
                font.bold: true; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
            Text {
                id: distancedisplay
                //text: map.center.longitude.toFixed(8).toString()
                property double distance: map.center.distanceTo(monitormodel.waypoint)/1000
                text: distance.toFixed(3).toString()
                visible: (distance !== 0)
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
        }
    }

    ToolButton {
        id: gaugebutton

        x: 10;
        y: 10
        width: buttonwidth
        height: width

        source: "qrc:/Components/gauge.png";
        bgcolor: "black"

        onClicked: {
            console.log("Mapview.Gauge")
            stack.push(dashboard)
        }
    }

    ToolButton {
        id: wptbutton

        x: 20 + buttonwidth
        y: 10
        width: buttonwidth
        height: width

        source: "qrc:/Components/flag.png";
        bgcolor: "black"

        onClicked: {
            console.log("Mapview.Waypoint",map.center.latitude,map.center.longitude)
            monitormodel.waypoint = QtPositioning.coordinate(map.center.latitude,map.center.longitude)
        }
    }

    ToolButton {
        id: exit

        y: 10;
        x: parent.width - (10+buttonwidth)
        width: buttonwidth
        height: width

        source: "qrc:/Components/exit.png";
        bgcolor: "black"

        onClicked: {
            console.log("Mapview.Exit")
            root.quit()
        }
    }

    ToolButton {
        id: zoomin

        x: root.width - 10 -buttonwidth; y: root.height - 2 * (10 + buttonwidth)
        width: buttonwidth
        height: width

        source: "qrc:/Components/zoom-in.png";
        bgcolor: "black"

        onClicked: {
            console.log("Mapview.ZoomIn")
            map.zoomLevel += 1
        }
    }

    ToolButton {
        id: zoomout

        x: root.width - 10 -buttonwidth; y: root.height - 1 * (10 + buttonwidth)
        width: buttonwidth
        height: width

        source: "qrc:/Components/zoom-out.png";
        bgcolor: "black"

        onClicked: {
            console.log("Mapview.ZoomOut")
            map.zoomLevel -= 1
        }
    }
}

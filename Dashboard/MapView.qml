import QtQuick 2.5
import QtPositioning 5.5
import QtLocation 5.5
import QtSensors 5.0
import QtQuick.Layouts 1.2
import Proj4 1.0
import "qrc:/Components"
import "qrc:/Models"
import "qrc:/Location"

Page {
    id: root
    anchors.fill: parent
    onPushed: console.log("Mapview.onPushed")
    onPopped: console.log("Mapview.onPopped")

    signal quit()

    property bool init: false
    property var stack: null
    property bool followme: true
    //property int buttonwidth: 50 * screen.scale

    PositionSource {
        id: positionsource
        updateInterval: 250
        active: true
        property var current: QtPositioning.coordinate(53.21938317,6.56820053)
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

    property bool testmode: true
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
        onRouteChanged: map.updateRoute()

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
        y: parent.y - screen.buttonwidth -10
        height: parent.height + 2*screen.buttonwidth +20
        zoomLevel: maximumZoomLevel - 2
        property bool followcurrent: true
        center: QtPositioning.coordinate(53.21938317,6.56820053)
        property var p4center: Proj4.coordinate(0,0,0)
        onCenterChanged: {
            if (center !== positionsource.current)
                followcurrent = false
            p4center = Proj4.coordinate(center.longitude,center.latitude,0)
        }

        plugin: Plugin {
            id: plugin
            name:"osm"
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
                width: screen.buttonwidth
                height: width

                MouseHandler {
                    anchors.fill: parent
                    onSingleTap: {
                        map.followcurrent = true
                        map.center = positionsource.current
                    }
                    onDoubleTap: {
                        stack.push(locationoptions)
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
                width: screen.buttonwidth
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

        MapPolyline {
            line.width: 5
            line.color: "blue"
            path: monitormodel.route
            visible: (path.length > 1)
        }

        Component {
            id: routepointdelegate

            MapQuickItem {
                id: routepointitem
                anchorPoint.x: screen.buttonwidth/4
                anchorPoint.y: screen.buttonwidth/4
                coordinate: modelData
                onCoordinateChanged: console.log("MapView.map.routepointdelegate.onCoordinateChanged",coordinate.latitude,coordinate.longitude)
                zoomLevel: 0.0

                sourceItem: Image {
                    id: routepointimage
                    source: "qrc:/Components/locator_green.png"
                    width: screen.buttonwidth/2
                    height: width
                }

                MouseHandler {
                    anchors.fill: parent
                    onSingleTap: monitormodel.setWaypoint(modelData)
                    onLongTap: monitormodel.removeRoutePoint(modelData)
                }

                Component.onCompleted: map.addMapItem(routepointitem)
            }
        }

        Repeater {
            id: routedisplay
            model: monitormodel.route
            delegate: routepointdelegate
        }

        function updateRoute() {
            console.log("MapView.map.updateRoute()")
        }

        activeMapType: supportedMapTypes[mapoptions.selectedmap]
    }

    property list<QtObject> availableTransformers: [
        AddressTransformer {
            id: addresstransformer
            coordinate: map.center
        },
        Wgs84Transformer {
            id: wgs84transformer
            coordinate: map.center
            datumformat: mapoptions.selectedformat
        },
        UtmTransformer {
            id: utmwgs84transformer
            coordinate: map.center
            title: "UTM/WGS84"
            ellps: "+ellps=WGS84"
            datum: "+datum=WGS84"
            zone: map.center.longitude > 180
                ? Math.floor((map.center.longitude - 180) / 6) + 1
                : Math.floor((map.center.longitude + 180) / 6) + 1
            south: (map.center.latitude < 0)
        },
        UtmTransformer {
            id: utmed50transformer
            coordinate: map.center
            title: "UTM/ED50"
            ellps: "+ellps=intl"
            datum: "+towgs84=-87,-98,-121,0,0,0,0"
            zone: map.center.longitude > 180
                ? Math.floor((map.center.longitude - 180) / 6) + 1
                : Math.floor((map.center.longitude + 180) / 6) + 1
            south: (map.center.latitude < 0)
        },
        RDTransformer {
            id: rdtransformer
            coordinate: map.center
        }
    ]

    MapOptions {
        id: mapoptions
        title: "Map Options"
        maptypes: map.supportedMapTypes
        transformers: availableTransformers
    }

    LocationOptions {
        id: locationoptions
        title: "Location"
        infobox: availableTransformers[mapoptions.selectedtransformer].inputbox
        onPositionChanged: {
            console.log("locationoptions.onPositionChanged:",position.latitude,position.longitude)
            map.center = position
        }
    }

    Rectangle {
        id: infobox
        x: 10
        y: root.height - height - 10
        width: 3*screen.buttonwidth+20
        height: screen.buttonwidth*2 + 10
        color: "white"
        border.color: "black"
        opacity: 0.7
        radius: 20

        MouseArea {
            anchors.fill: parent
            onClicked: stack.push(mapoptions)
        }

        property var oldbox
        property var outputbox: availableTransformers[mapoptions.selectedtransformer].outputbox
        onOutputboxChanged: {
            if (oldbox)
                oldbox.parent = null
            oldbox = outputbox
            outputbox.parent = infobox
        }
    }

    property string distancemode: "wpt"

    ToolButton {
        id: gaugebutton

        x: 10
        y: 10
        width: screen.buttonwidth
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

        x: 20 + screen.buttonwidth
        y: 10
        width: screen.buttonwidth
        height: width

        source: "qrc:/Components/flag.png";
        bgcolor: "black"

        onShortPressed: {
            //console.log("Mapview.wptbutton.onShortPressed",map.center.latitude,map.center.longitude)
            monitormodel.setWaypoint(QtPositioning.coordinate(map.center.latitude,map.center.longitude))
            distancemode = "wpt"
        }
        onLongPressed: {
            //console.log("Mapview.wptbutton.onLongPressed")
            monitormodel.resetWaypoint()
        }
    }

    ToolButton {
        id: rtebutton

        x: 30 + 2*screen.buttonwidth
        y: 10
        width: screen.buttonwidth
        height: width

        source: "qrc:/Components/route-2.png";
        bgcolor: "black"

        onShortPressed: {
            console.log("Mapview.rtebutton.onShortPressed",map.center.latitude,map.center.longitude)
            monitormodel.addRoutePoint(QtPositioning.coordinate(map.center.latitude,map.center.longitude))
            distancemode = "rte"
        }
        onLongPressed: {
            console.log("Mapview.rtebutton.onLongPressed")
            monitormodel.resetRoute()
            distancemode = "wpt"
        }
    }

    ToolButton {
        id: exit

        y: 10;
        x: parent.width - (10+screen.buttonwidth)
        width: screen.buttonwidth
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

        x: root.width - 10 -screen.buttonwidth; y: root.height - 2 * (10 + screen.buttonwidth)
        width: screen.buttonwidth
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

        x: root.width - 10 -screen.buttonwidth; y: root.height - 1 * (10 + screen.buttonwidth)
        width: screen.buttonwidth
        height: width

        source: "qrc:/Components/zoom-out.png";
        bgcolor: "black"

        onClicked: {
            console.log("Mapview.ZoomOut")
            map.zoomLevel -= 1
        }
    }
}

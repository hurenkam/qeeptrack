import QtQuick 2.5
import QtLocation 5.5
import QtPositioning 5.5
import QtQuick.Layouts 1.2
import "qrc:/Components"

Page {
    id: root
    anchors.fill: parent
    //color: "black"
    onPushed: console.log("Mapview.onPushed")
    onPopped: console.log("Mapview.onPopped")

    signal quit()

    property bool init: false
    property var waypoint
    property var stack: null
    property bool followme: true
    property int buttonwidth: 50 * screen.scale

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

    PositionSource {
        id: positionSource
        active: root.followme
        property var current

        onPositionChanged: {
            if (positionSource.position) {
                if (map.followcurrent)
                    map.center = positionSource.position.coordinate
                else
                    map.followcurrent = false

                current = positionSource.position.coordinate

                if (!init) {
                    console.log ("setting waypoint to current location")
                    markwaypoint.coordinate = current
                    inittimer.running = true
                }
            }
        }
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
        center: QtPositioning.coordinate(47.24372,10.72052) // Hoch Imst
              //QtPositioning.coordinate(42.627,0.765) // Hospice de Vielha (GR11)
        onCenterChanged: if (center !== positionSource.current) followcurrent = false

        plugin: Plugin {
            id: plugin
            name:"osm"
        }

        MouseArea {
            anchors.fill: parent
            onPressAndHold: map.followcurrent=false
        }

        MapQuickItem {
            id: markcurrentposition
            anchorPoint.x: currentimage.width/2
            anchorPoint.y: currentimage.height/2
            coordinate: positionSource.current
            visible: (!map.followcurrent && positionSource.current)
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
            coordinate: waypoint
            //visible: (waypoint)
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

    Image {
        id: locator
        x: (root.width-width)/2
        y: (root.height-height)/2
        width: buttonwidth
        height: width
        source: iscurrent? "qrc:/Components/locator_green.png" : "qrc:/Components/locator_red.png"
        property bool iscurrent: (map.followcurrent && positionSource.current)

        MouseArea {
            anchors.fill: parent
            onClicked: {
                map.followcurrent = true
                map.center = positionSource.current
            }
        }
    }

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
            rows: 3

            Text {
                text: "WGS84"
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize
                style: Text.Raised; styleColor: "white"
                Layout.columnSpan: 2
            }
            Text {
                text: "Lat:"
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: map.center.latitude.toFixed(8).toString()
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: "Lon:"
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: map.center.longitude.toFixed(8).toString()
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.7
                style: Text.Raised; styleColor: "white"
            }
        }
    }

    ToolButton {
        id: gauge

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

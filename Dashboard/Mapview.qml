import QtQuick 2.5
import QtLocation 5.5
import QtPositioning 5.5
import "qrc:/Components"

Page {
    id: root
    anchors.fill: parent
    //color: "black"
    onPushed: console.log("Mapview.onPushed")
    onPopped: console.log("Mapview.onPopped")

    signal quit()

    property var stack: null
    property bool followme: true
    property int buttonwidth: 50 * screen.scale

    Dashboard {
        id: dashboard
        stack: root.stack
    }

    PositionSource {
        id: positionSource
        active: root.followme

        onPositionChanged: {
            if (positionSource.position) {
                locator.iscurrent = true
                map.center = positionSource.position.coordinate
            }
        }
    }

    Map {
        id: map
        anchors.fill: parent
        zoomLevel: maximumZoomLevel - 2
        center {
            latitude: 51.58482000
            longitude: 5.31952000
        }

        plugin: Plugin {
            id: plugin
            name:"osm"

            PluginParameter { name: "osm.useragent"; value: "qeeptrack" }
            PluginParameter { name: "osm.mapping.host"; value: "http://osm.tile.server.address/" }
            PluginParameter { name: "osm.mapping.copyright"; value: "(c) Mark Hurenkamp (2015)" }
            PluginParameter { name: "osm.routing.host"; value: "http://osrm.server.address/viaroute" }
            PluginParameter { name: "osm.geocoding.host"; value: "http://geocoding.server.address" }        }
    }

    MouseHandler {
        anchors.fill: parent
        onSingleTap: stack.push(dashboard)
    }

    Image {
        id: locator
        x: (root.width-width)/2
        y: (root.height-height)/2
        width: buttonwidth
        height: width
        source: iscurrent? "qrc:/Components/locator_green.png" : "qrc:/Components/locator_red.png"
        property bool iscurrent: false
    }

    ToolButton {
        id: exit

        x: 10; y: 10
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

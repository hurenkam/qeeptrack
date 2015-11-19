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
        x: parent.x; width: parent.width;
        y: parent.y-60; height: parent.height+120

        zoomLevel: maximumZoomLevel - 2
        center { latitude: 51.47292064801667; longitude: 5.489283303657714 } // Home

        plugin: Plugin {
            id: plugin
            name:"osm"
        }
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

    Rectangle {
        id: infobox
        x: 10
        y: root.height - height - 10
        width: root.width - buttonwidth - 30
        height: buttonwidth*2 + 10
        color: "white"
        border.color: "black"
        opacity: 0.5
        radius: 20

        ColumnLayout {
            x: 15
            y: 15
            width: parent.width-30
            height: parent.height-30
            spacing: 5

            Text {
                text: "WGS84"
                color: "black"
                font.bold: true; font.pixelSize: screen.pixelSize*1.5
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: "Latitude:"
                color: "black"
                font.bold: true; font.pixelSize: screen.pixelSize
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: map.center.latitude.toFixed(8).toString()
                color: "black"
                font.bold: false; font.pixelSize: screen.pixelSize*0.7
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: "Longitude: "
                color: "black"
                font.bold: true; font.pixelSize: screen.pixelSize
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: map.center.longitude.toFixed(8).toString()
                color: "black"
                font.bold: false; font.pixelSize: screen.pixelSize*0.7
                style: Text.Raised; styleColor: "white"
            }
        }
    }

    ToolButton {
        id: options

        x: 10; y: 10
        width: buttonwidth
        height: width

        source: "qrc:/Components/options.png";
        bgcolor: "black"

        onClicked: {
            console.log("Mapview.Options")
            stack.push(dashboard)
        }
    }

    ToolButton {
        id: exit

        x: root.width - width - 10; y: 10
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

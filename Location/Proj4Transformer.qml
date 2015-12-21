import QtQuick 2.5
import QtPositioning 5.5
import QtQuick.Layouts 1.2
import Proj4 1.0

Transformer {
    id: root

    //============================
    // values to be set by client
    //============================
    property int digits: 0
    property string source: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
    property string destination: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
    property string xname: "Longitude"
    property string yname: "Latitude"

    //===================================
    // result values to be read by client
    //===================================
    property string forwardedx: forwarded.x.toFixed(digits).toString()
    property string forwardedy: forwarded.y.toFixed(digits).toString()

    //===============
    // implementation
    //===============
    Component.onCompleted: internal.update()
    onSourceChanged: internal.updateSource()
    onDestinationChanged: internal.updateDestination()

    Item {
        id: internal
        property var _source
        property var _destination

        function update() {
            updateSource()
            updateDestination()
            root.transform()
        }

        function updateSource() {
            _source = Proj4.projection(root.source);
            console.log("Transformer.updateSource()",_source)
        }

        function updateDestination() {
            _destination = Proj4.projection(root.destination);
            console.log("Transformer.updateDestination()",_destination)
        }
    }

    onCoordinateChanged: transform()
    function transform() {
        var c = Proj4.coordinate(coordinate.longitude,coordinate.latitude,0)
        forwarded = Proj4.transform(c,internal._source,internal._destination)
    }

    function inverse(p4coordinate) {
        //console.log("Transformer.inverse()",p4coordinate.x,p4coordinate.y)
        var r = Proj4.transform(p4coordinate,internal._destination,internal._source)
        var result = QtPositioning.coordinate(r.y,r.x,0)
        //console.log("Transformer.inverse()",result.longitude,result.latitude)
        return result
    }

    outputbox: GridLayout {
            x: 15
            y: 15
            width: parent.width-30
            height: parent.height-30
            columns: 2
            rows: 4

            Text {
                text: root.title
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize *0.7
                style: Text.Raised; styleColor: "white"
                Layout.columnSpan: 2
            }
            Text {
                text: root.xname
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize*0.5
                style: Text.Raised; styleColor: "white"
            }
            Text {
                id: xtext
                text: root.forwardedx
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.5
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: root.yname
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize*0.5
                style: Text.Raised; styleColor: "white"
            }
            Text {
                id: ytext
                text: root.forwardedy
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.5
                style: Text.Raised; styleColor: "white"
            }
            Text {
                text: "Dist:"
                color: "black"
                visible: (distancedisplay.distance !== 0)
                font.bold: true; font.pointSize: screen.pointSize*0.5
                style: Text.Raised; styleColor: "white"
            }
            Text {
                id: distancedisplay
                property double distance: (distancemode=="wpt")? map.center.distanceTo(monitormodel.waypoint)/1000 : monitormodel.routeDistance/1000
                text: distance.toFixed(3).toString()
                visible: (distance !== 0)
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.5
                style: Text.Raised; styleColor: "white"
            }
        }
}

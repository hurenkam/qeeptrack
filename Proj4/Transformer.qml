import QtQuick 2.5
import QtPositioning 5.5
import Proj4 1.0

Item {
    id: root


    //============================
    // values to be set by client
    //============================
    property string title: "<unknown>"
    property int digits: 0
    property var coordinate:  QtPositioning.coordinate(0,0,0)
    property string source: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
    property string destination: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
    property string xname: "Longitude"
    property string yname: "Latitude"
    property var inputbox


    //===================================
    // result values to be read by client
    //===================================
    property var forwarded
    property var reversed

    signal positionInput(var position)

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
}

import QtQuick 2.5
import QtPositioning 5.5
import Proj4 1.0

Item {
    id: root

    //============================
    // values to be set by client
    //============================
    property string title: "<unknown>"
    property var coordinate: QtPositioning.coordinate(0,0,0)
    property var inputbox
    property var outputbox
    property bool islatlon: false

    //===================================
    // result values to be read by client
    //===================================
    property var forwarded
    property var reversed

    signal positionInput(var position)
}

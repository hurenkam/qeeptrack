import QtQuick 2.0

Item {
    property var position: null
    property var waypoint: null
    property var elapsedtime: null
    property var covereddistance: null
    property var ascent: null
    property var descent: null

    signal remainingDistanceChanged(double value)
    signal remainingAscentChanged(double value)
    signal remainingTimeChanged(date value)
    signal bearingChanged(double value)
}

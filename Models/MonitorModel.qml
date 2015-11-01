import QtQuick 2.0

Item {
    id: root

    property bool enableanimations: true

    property double distance: 0
    Behavior on distance {
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }
    onDistanceChanged: distanceUpdate(distance)
    signal distanceUpdate(double value)

    property double remainingDistance: 0
    Behavior on remainingDistance {
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }
    onRemainingDistanceChanged: remainingDistanceUpdate(remainingDistance)
    signal remainingDistanceUpdate(double value)

    property double remainingAscent: 0
    Behavior on remainingAscent {
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }
    onRemainingAscentChanged: remainingDistanceUpdate(remainingAscent)
    signal remainingAscentUpdate(double value)

    property double bearing: 0
    Behavior on bearing {
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }
    onBearingChanged: bearingUpdate(bearing)
    signal bearingUpdate(double value)
    signal remainingTimeUpdate(date value)

    property var position: null
    onPositionChanged: updatePosition()
    property var waypoint: null
    onWaypointChanged: updatePosition()

    function updatePosition()
    {
        if (position == null)
            return

        if (!position.coordinate.isValid)
            return

        if (!internal.valid)
            internal.initialise()

        updateDistance()

        if (waypoint == null)
            return

        updateBearing()
        updateRemainingDistance()

        if (position.altitudeValid)
        {
            updateRemainingAscent()
        }

        if (elapsedtime != null)
        {
            updateRemainingTime()
        }
    }

    property var elapsedtime: null
    onElapsedtimeChanged: updateTime()
    function updateTime() {
        if ((elapsedtime == null) || (position == null) || (waypoint == null))
            return

        if (!internal.started)
            internal.initialise()

        updateRemainingTime()
    }

    Item {
        id: internal
        property variant start: null
        property variant previous: null
        property int hysteresis: 25
        property bool valid: false

        function initialise()
        {
            start = root.position.coordinate
            previous = root.position.coordinate
            valid = true
        }
    }

    function updateBearing() {
        bearing = position.coordinate.bearingTo(waypoint.coordinate)
    }

    function updateDistance() {
        var delta = internal.previous.distanceTo(position.coordinate)
        if (delta > internal.hysteresis)
        {
            internal.previous = position.coordinate
            root.distance += delta
        }
    }

    function updateRemainingDistance() {
        remainingDistance = position.coordinate.distanceTo(waypoint)
    }

    function updateRemainingAscent() {
        remainingAscent = waypoint.coordinate.altitude - position.coordinate.altitude
    }

    function updateRemainingTime() {
        var remaining = 0
        var elapsedseconds = (elapsedtime.getTime() - new Date(0,0,0).getTime())/1000

        if ((position.coordinate.isValid) && (distance != null))
        {
            var delta = (distance+remaining)/distance * elapsedseconds
            remaining = (delta > remaining)? delta : remaining
        }

        if (position.altitudeValid)
        {
            var ascent = position.coordinate.altitude - start.altitude
            var remainingascent = waypoint.altitude - position.coordinate.altitude
            var delta = (ascent+remainingascent)/ascent * elapsedseconds
            remaining = (delta > remaining)? delta : remaining
        }

        var temp = new Date(0,0,0)
        temp.setTime(temp.getTime()+remaining*1000)
        remainingTime = temp
    }
}

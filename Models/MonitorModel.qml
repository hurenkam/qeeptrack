import QtQuick 2.0

Item {
    id: root

    signal distanceUpdate(double value)
    signal remainingDistanceUpdate(double value)
    signal remainingAscentUpdate(double value)
    signal bearingUpdate(double value)
    signal remainingTimeUpdate(date value)
    signal averageSpeedUpdate(double value)

    property bool enableanimations: true
    property double distance: 0
    property double remainingDistance: 0
    property double remainingAscent: 0
    property double bearing: 0
    property double averageSpeed: 0

    onDistanceChanged: distanceUpdate(distance)
    onRemainingDistanceChanged: remainingDistanceUpdate(remainingDistance)
    onRemainingAscentChanged: remainingDistanceUpdate(remainingAscent)
    onBearingChanged: bearingUpdate(bearing)
    onAverageSpeedChanged: averageSpeedUpdate(averageSpeed)

    Behavior on distance {
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    Behavior on remainingDistance {
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    Behavior on remainingAscent {
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    Behavior on bearing {
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    property var position: null
    property var waypoint: null
    property var elapsedtime: null
    onPositionChanged: updatePosition()
    onWaypointChanged: updatePosition()
    onElapsedtimeChanged: updateTime()

    Item {
        id: internal
        property variant start: null
        property variant previous: null
        property double distance: 0
        property double delta: 0
        property int hysteresis: 25
        property bool valid: false

        function initialise()
        {
            start = root.position.coordinate
            previous = root.position.coordinate
            distance = 0
            delta = 0
            valid = true
        }
    }

    function updatePosition()
    {
        if ((position == null) || (!position.coordinate.isValid))
            return

        if (!internal.valid)
            internal.initialise()

        updateDistance()
        if (elapsedtime != null)
            updateAverageSpeed()

        if (waypoint == null)
            return

        updateBearing()
        updateRemainingDistance()

        if (position.altitudeValid)
            updateRemainingAscent()

        if (elapsedtime != null)
            updateRemainingTime()
    }

    function updateTime() {
        if ((elapsedtime == null) || (position == null) || (waypoint == null))
            return

        if (!internal.started)
            internal.initialise()

        updateRemainingTime()
    }

    function updateBearing() {
        bearing = position.coordinate.bearingTo(waypoint.coordinate)
    }

    function updateDistance() {
        internal.delta = internal.previous.distanceTo(position.coordinate)
        if (internal.delta > internal.hysteresis)
        {
            internal.previous = position.coordinate
            internal.distance += internal.delta
            internal.delta = 0
        }
        root.distance = internal.distance + internal.delta
    }

    function updateAverageSpeed() {
        var elapsedseconds = (elapsedtime.getTime() - new Date(0,0,0).getTime())/1000
        root.averageSpeed = root.distance/elapsedseconds * 3.6
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

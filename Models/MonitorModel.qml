import QtQuick 2.0
import "qrc:/Components"

Item {
    id: root

    property bool   enableanimations: true
    property double tripDistance: 0
    property double totalDistance: 0
    property double remainingDistance: 0
    property double remainingAscent: 0
    property date   remainingTime: new Date(0,0,0)
    property double bearing: 0
    property double averageSpeed: 0
    property string prefix: "qeeptrack.monitormodel."

    property bool testmode: false

    Behavior on tripDistance {
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    Behavior on totalDistance {
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

    property var position
    property var waypoint
    property var elapsedtime: null
    onPositionChanged: updatePosition()
    onWaypointChanged: updatePosition()
    onElapsedtimeChanged: updateTime()

    SettingsDatabase {
        id: settings
        filename: "qeeptrack"
        prefix: root.prefix

        Component.onCompleted: {
            internal.totalDistance = settings.getValue("totalDistance",0)
        }
    }

    Item {
        id: internal
        property variant start: null
        property variant previous: null
        property double tripDistance: 0
        property double totalDistance: 0
        property double delta: 0
        property int hysteresis: 25
        property bool valid: false

        function initialise()
        {
            start = root.position.coordinate
            if (!waypoint)
                waypoint = start
            previous = root.position.coordinate
            tripDistance = 0
            delta = 0
            valid = true
        }
    }

    function reset() {
        internal.valid = false
    }

    function updatePosition()
    {
        if ((!position) || (!position.coordinate.isValid))
            return

        if (!internal.valid)
            internal.initialise()

        updateTripAndTotalDistance()

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
        bearing = position.coordinate.azimuthTo(waypoint)
    }

    function updateTripAndTotalDistance() {
        internal.delta = internal.previous.distanceTo(position.coordinate)
        if (internal.delta > internal.hysteresis)
        {
            internal.previous = position.coordinate
            internal.tripDistance += internal.delta
            internal.totalDistance += internal.delta
            internal.delta = 0
        }
        root.tripDistance = internal.tripDistance + internal.delta
        root.totalDistance = internal.totalDistance + internal.delta
    }

    function updateAverageSpeed() {
        var elapsedseconds = (elapsedtime.getTime() - new Date(0,0,0).getTime())/1000
        root.averageSpeed = root.tripDistance/elapsedseconds * 3.6
    }

    function updateRemainingDistance() {
        remainingDistance = position.coordinate.distanceTo(waypoint)
    }

    function updateRemainingAscent() {
        remainingAscent = waypoint.altitude - position.coordinate.altitude
    }

    function updateRemainingTime() {
        var remaining = 0
        var elapsedseconds = (elapsedtime.getTime() - new Date(0,0,0).getTime())/1000

        if ((position.coordinate.isValid) && (tripDistance != null))
        {
            var delta = (tripDistance+remaining)/tripDistance * elapsedseconds
            remaining = (delta > remaining)? delta : remaining
        }

        if (position.altitudeValid)
        {
            var ascent = position.coordinate.altitude - internal.start.altitude
            var remainingascent = waypoint.altitude - position.coordinate.altitude
            var delta = (ascent+remainingascent)/ascent * elapsedseconds
            remaining = (delta > remaining)? delta : remaining
        }

        var temp = new Date(0,0,0)
        temp.setTime(temp.getTime()+remaining*1000)
        remainingTime = temp
    }
}

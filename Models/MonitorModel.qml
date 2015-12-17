import QtQuick 2.0
import "qrc:/Components"

Item {
    id: root

    property bool   enableanimations: true
    property string prefix: "qeeptrack.monitormodel."

    property bool testmode: false

    property list<QtObject> availablesources: [
        DoubleSource   { id: tripDistance;      title: "Trip Distance";      gaugetype: "distance";    units: "m" },
        DoubleSource   { id: totalDistance;     title: "Total Distance";     gaugetype: "distance";    units: "m" },
        DoubleSource   { id: remainingDistance; title: "Remaining Distance"; gaugetype: "distance";    units: "m" },
        DoubleSource   { id: remainingAscent;   title: "Remaining Ascent";   gaugetype: "altimeter";   units: "m" },
        DateSource     { id: remainingTime;     title: "Remaining Time";     gaugetype: "clock";       units: "date" },
        RotationSource { id: bearing;           title: "Bearing";            gaugetype: "compass";     units: "degrees" },
        DoubleSource   { id: averageSpeed;      title: "Average Speed";      gaugetype: "speedometer"; units: "km/h" }
    ]

    property var position
    property var waypoint
    property var route
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
        property double routeDistance: 0
        property double delta: 0
        property int hysteresis: 25
        property bool valid: false

        onRouteDistanceChanged: console.log("MonitorModel.internal.onRouteDistanceChanged:",routeDistance)

        function initialise()
        {
            start = root.position.coordinate
            if (!waypoint)
                waypoint = start
            previous = root.position.coordinate
            tripDistance.value = 0
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
        bearing.value = position.coordinate.azimuthTo(waypoint)
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
        tripDistance.value = internal.tripDistance + internal.delta
        totalDistance.value = internal.totalDistance + internal.delta
    }

    function updateAverageSpeed() {
        var elapsedseconds = (elapsedtime.getTime() - new Date(0,0,0).getTime())/1000
        averageSpeed.value = root.tripDistance/elapsedseconds * 3.6
    }

    function updateRemainingDistance() {
        remainingDistance.value = position.coordinate.distanceTo(waypoint)
    }

    function updateRemainingAscent() {
        remainingAscent.value = waypoint.altitude - position.coordinate.altitude
    }

    function updateRemainingTime() {
        var remaining = 0
        var elapsedseconds = (elapsedtime.getTime() - new Date(0,0,0).getTime())/1000

        if ((position.coordinate.isValid) && (tripDistance.value != null))
        {
            var delta = (tripDistance.value+remaining)/tripDistance.value * elapsedseconds
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
        remainingTime.value = temp
    }

    function setWaypoint(coordinate) {
        waypoint = coordinate
    }

    function resetWaypoint() {
    }

    function addRoutePoint(coordinate) {
        if (route.length > 0)
            internal.routeDistance += coordinate.distanceTo(route[route.length-1])

        route.push(coordinate)
        routeChanged()
    }

    function calculateRouteLength() {
        var distance = 0.0
        for (var i=1; i< route.length; i++)
        {
            distance += route[i-1].distanceTo(route[i])
        }
        internal.routeDistance = distance
    }

    function removeRoutePoint(coordinate) {
        var index = route.lastIndexOf(coordinate)
        if (index != -1) {
            route.splice(index,1)
            calculateRouteLength()
            routeChanged()
        }
    }

    function resetRoute() {
        route = []
        internal.routeDistance = 0
        routeChanged()
    }

    Component.onCompleted: {
        resetWaypoint()
        resetRoute()
    }
}

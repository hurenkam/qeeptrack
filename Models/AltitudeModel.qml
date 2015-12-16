import QtQuick 2.5
import QtPositioning 5.5

Item {
    id: root
    property bool enableanimations: true
    readonly property bool valid: internal.valid

    property list<QtObject> availablesources: [
        DoubleSource { id: current; title: "Current"; name: "current"; units: "m" },
        DoubleSource { id: average; title: "Average"; name: "average"; units: "m" },
        DoubleSource { id: minimum; title: "Minimum"; name: "minimum"; units: "m" },
        DoubleSource { id: maximum; title: "Maximum"; name: "maximum"; units: "m" },
        DoubleSource { id: ascent;  title: "Ascent";  name: "ascent";  units: "m" },
        DoubleSource { id: descent; title: "Descent"; name: "descent"; units: "m" }
    ]

    Item {
        id: internal
        property bool valid: false
        property var average: new Array()
        property int averagekeep: 10
        property double previous: 0
        property int hysteresis: 25
    }

    function reset()
    {
        internal.valid = false
    }

    property bool testmode: false
    Timer {
        id: timer
        interval: 1000;
        running: testmode;
        repeat: true;

        property double delta: 1
        property double altitude: 1200
        onAltitudeChanged: updateAltitude(altitude)

        onTriggered: {
            if (altitude < 1200)
                delta = 1
            if (altitude > 2800)
                delta = -2
            altitude += delta
        }
    }

    property var position: null
    onPositionChanged: if (!testmode) updatePosition(position)
    function updatePosition(value)
    {
        if (value == null)
            return
        if (!value.altitudeValid)
            return

        updateAltitude(value.coordinate.altitude)
    }

    function updateAltitude(value)
    {
        //console.log("AltitudeModel.updateAltitude: ", value)
        if (!internal.valid)
        {
            average.value = value
            minimum.value = value
            maximum.value = value
            ascent.value = 0
            descent.value = 0
            internal.previous = current.value
            internal.average = new Array()
            internal.valid = true
        }
        current.value = value

        minimum.value = (current.value < minimum.value)? current.value : minimum.value
        maximum.value = (current.value > maximum.value)? current.value : maximum.value

        if (current.value > internal.previous + internal.hysteresis)
        {
            ascent.value += (current.value - internal.previous)
            internal.previous = current.value
        }

        if (current.value < internal.previous - internal.hysteresis)
        {
            descent.value += (internal.previous - current.value)
            internal.previous = current.value
        }

        if (internal.average.length == internal.averagekeep)
        {
            var old = internal.average[0]
            internal.average.shift()
            internal.average.push(current.value)
            average.value = average.value - old/(internal.averagekeep) + current.value/(internal.averagekeep)
        } else {
            internal.average.push(current.value)
            average.value = average.value/(internal.average.length) * (internal.average.length-1) + current.value/(internal.average.length)
        }
    }
}

import QtQuick 2.5
import QtPositioning 5.5

Item {
    id: root
    property bool enableanimations: true
    readonly property bool valid: internal.valid

    property double current: 0
    Behavior on current {
        id: currentanimation
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    property double average: 0
    Behavior on average {
        id: averageanimation
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    property double minimum: 0
    Behavior on minimum {
        id: minimumanimation
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    property double maximum: 0
    Behavior on maximum {
        id: maximumanimation
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    property double ascent:  0
    Behavior on ascent {
        id: ascentanimation
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

    property double descent: 0
    Behavior on descent {
        id: descentanimation
        enabled: root.enableanimations
        NumberAnimation {
            duration: 1000
        }
    }

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
            average = value
            minimum = value
            maximum = value
            ascent = 0
            descent = 0
            internal.previous = current
            internal.average = new Array()
            internal.valid = true
        }
        current = value

        minimum = (current < minimum)? current : minimum
        maximum = (current > maximum)? current : maximum

        if (current > internal.previous + internal.hysteresis)
        {
            ascent += (current - internal.previous)
            internal.previous = current
        }

        if (current < internal.previous - internal.hysteresis)
        {
            descent += (internal.previous - current)
            internal.previous = current
        }

        if (internal.average.length == internal.averagekeep)
        {
            var old = internal.average[0]
            internal.average.shift()
            internal.average.push(current)
            average = average - old/(internal.averagekeep) + current/(internal.averagekeep)
        } else {
            internal.average.push(current)
            average = average/(internal.average.length) * (internal.average.length-1) + current/(internal.average.length)
        }
    }
}

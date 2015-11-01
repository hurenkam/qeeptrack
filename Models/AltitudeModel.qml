import QtQuick 2.5
import QtPositioning 5.5

Item {
    id: root
    signal currentUpdate(double value)
    signal averageUpdate(double value)
    signal minimumUpdate(double value)
    signal maximumUpdate(double value)
    signal ascentUpdate (double value)
    signal descentUpdate(double value)

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

    onCurrentChanged: currentUpdate(current)
    onAverageChanged: averageUpdate(average)
    onMinimumChanged: minimumUpdate(minimum)
    onMaximumChanged: maximumUpdate(maximum)
    onAscentChanged:  ascentUpdate (ascent)
    onDescentChanged: descentUpdate(descent)

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

    property var position: null
    onPositionChanged: updatePosition(position)
    function updatePosition(value)
    {
        if (value == null)
            return
        if (!value.altitudeValid)
            return

        if (!internal.valid)
        {
            average = value.coordinate.altitude
            minimum = value.coordinate.altitude
            maximum = value.coordinate.altitude
            ascent = 0
            descent = 0
            internal.previous = current
            internal.average = new Array()
            internal.valid = true
        }
        current = value.coordinate.altitude

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

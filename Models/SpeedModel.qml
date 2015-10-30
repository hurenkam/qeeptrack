import QtQuick 2.5
import QtPositioning 5.5

Item {
    signal currentUpdate(double value)
    signal averageUpdate(double value)
    signal minimumUpdate(double value)
    signal maximumUpdate(double value)

    readonly property bool valid: internal.valid
    property double current: 0
    property double average: 0
    property double minimum: 0
    property double maximum: 0
    onCurrentChanged: currentUpdate(current)
    onAverageChanged: averageUpdate(average)
    onMinimumChanged: minimumUpdate(minimum)
    onMaximumChanged: maximumUpdate(maximum)

    Item {
        id: internal
        property bool valid: false
        property var average: new Array()
        property int averagekeep: 10
        property int previous: 0
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
        if (!value.speedValid)
            return

        if (!internal.valid)
        {
            average = value.speed * 3.6
            minimum = value.speed * 3.6
            maximum = value.speed * 3.6
            internal.previous = current
            internal.average = new Array()
            internal.valid = true
        }
        current = value.speed * 3.6

        minimum = (current < minimum)? current : minimum
        maximum = (current > maximum)? current : maximum

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

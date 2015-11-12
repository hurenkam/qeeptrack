import QtQuick 2.5
import QtPositioning 5.5

Item {
    id: root
    signal currentUpdate(double value)
    signal averageUpdate(double value)
    signal minimumUpdate(double value)
    signal maximumUpdate(double value)

    readonly property bool valid: internal.valid
    property bool enableanimations: true
    property double current: 0
    Behavior on current {
        id: currentanimation
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

    onCurrentChanged: currentUpdate(current)
    //onAverageChanged: averageUpdate(average)
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

    property bool testmode: false
    Timer {
        id: timer
        interval: 1000;
        running: testmode;
        repeat: true;

        property double delta: 0.5
        property double speed: 50
        onSpeedChanged: updateSpeed(speed)

        onTriggered: {
            if (speed < 1)
                delta = 0.5
            if (speed > 120)
                delta = -5
            speed += delta
        }
    }

    property var position: null
    onPositionChanged: {
        if (!testmode)
            updatePosition(position)
    }

    function updatePosition(value)
    {
        if (value == null)
            return
        if (!value.speedValid)
            return

        updateSpeed(value.speed*3.6)
    }

    function updateSpeed(value)
    {
        if (!internal.valid)
        {
            //average = value
            minimum = value
            maximum = value
            internal.previous = current
            internal.average = new Array()
            internal.valid = true
        }
        current = value

        minimum = (current < minimum)? current : minimum
        maximum = (current > maximum)? current : maximum
    }
}

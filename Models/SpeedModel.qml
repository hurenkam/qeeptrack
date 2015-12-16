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

    property list<QtObject> availablesources: [
        DoubleSource { id: current; title: "Current"; name: "current"; units: "km/h"; onValueChanged: currentUpdate(current) },
        DoubleSource { id: minimum; title: "Minimum"; name: "minimum"; units: "km/h"; onValueChanged: minimumUpdate(minimum) },
        DoubleSource { id: maximum; title: "Maximum"; name: "maximum"; units: "km/h"; onValueChanged: maximumUpdate(maximum) }
    ]

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
    onPositionChanged: if (!testmode) updatePosition(position)

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
            minimum.value = value
            maximum.value = value
            internal.previous = current.value
            internal.average = new Array()
            internal.valid = true
        }
        current.value = value

        minimum.value = (current.value < minimum.value)? current.value : minimum.value
        maximum.value = (current.value > maximum.value)? current.value : maximum.value
    }
}

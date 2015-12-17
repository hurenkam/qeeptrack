import QtQuick 2.0

Item {
    id: root

    property date time: new Date(0,0,0)
    property date elapsed: new Date(0,0,0)

    property list<QtObject> availablesources: [
        DateSource { id: time;        title: "Current Time"; gaugetype: "clock"; units: "date"; onValueChanged: timeUpdate(value) },
        DateSource { id: elapsedtime; title: "Elapsed Time"; gaugetype: "clock"; units: "date"; onValueChanged: elapsedUpdate(value) }
    ]

    signal timeUpdate(date value)
    signal elapsedUpdate(date value)

    function reset() {
        timer.start = new Date()
    }

    Timer {
        id: timer
        interval: 1000;
        running: true;
        repeat: true;

        property date start: new Date()

        onTriggered: {
            var current = new Date()
            var elapsed = new Date(0,0,0)
            var delta = (current.getTime() - start.getTime())
            elapsed.setTime(elapsed.getTime() + delta)
            time.value = current
            elapsedtime.value = elapsed
        }
    }
}


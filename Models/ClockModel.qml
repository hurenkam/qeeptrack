import QtQuick 2.0

Item {
    id: root

    property date time: new Date(0,0,0)
    property date elapsed: new Date(0,0,0)

    onTimeChanged: timeUpdate(time)
    onElapsedChanged: elapsedUpdate(elapsed)

    signal timeUpdate(date value)
    signal elapsedUpdate(date value)

    Timer {
        id: timer
        interval: 1000;
        running: true;
        repeat: true;

        property date start: new Date()

        onTriggered: {
            var current = new Date()
            var delta = (current.getTime() - start.getTime())

            var elapsed = new Date(0,0,0)
            delta += elapsed.getTime()
            elapsed.setTime(delta)

            root.time = current
            root.elapsed = elapsed
        }
    }
}


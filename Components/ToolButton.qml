import QtQuick 2.5

Item {
    id: root
    width: parent.height*0.7
    height: parent.height*0.7
    smooth: true
    state: "released"
    property int interval: 0
    property bool selected: false
    property alias source: img.source
    property alias bgcolor: bg.color
    property alias bgradius: bg.radius
    property bool showbg: true

    Rectangle {
        id: bg
        visible: showbg? root.selected: false
        x: -3; y:-3; width: parent.width+6; height: parent.height+6
        radius: height/2
        color: "white"
    }

    Image {
        id: img
        visible: true
        smooth: true
        anchors.fill: parent
    }

    signal clicked
    signal repeat

    Timer {
        id: timer
        interval: 250; running: false; repeat: true
        onTriggered: root.repeat()
    }

    states: [
        State { name: "pressed";  PropertyChanges { target: root; scale: 0.9 } },
        State { name: "released"; }
    ]

    function pressed() {
        root.selected = true
        state = "pressed"
        if (repeat) {
            //root.repeat()
            timer.interval = root.interval
            timer.start()
        }
    }

    function released() {
        root.selected = false
        state = "released"
        if (repeat) {
            timer.stop()
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill:  parent
        onClicked: root.clicked();
        onPressed: root.pressed()
        onCanceled: root.released()
        onReleased: root.released()
    }
}

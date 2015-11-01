import QtQuick 2.5

Item {
    id: root
    anchors.fill: parent
    state: "idle"
    property int prevx: 0
    property int prevy: 0

    signal singleTap()
    signal doubleTap()
    signal longTap()

    states: [
        State { name: "idle"    },
        State { name: "pending" },
        State { name: "initial" },
        State { name: "second"  },
        State { name: "long"    }
    ]

    function handleSingleTapTimeout() {
        if (root.state == "pending") {
            console.log("singleTap")
            root.state = "idle"
            singleTap()
        }
    }

    function handleLongTapTimeout() {
        if ((root.state == "initial") || (root.state == "second")) {
            state = "long"
        }
    }

    function handleMousePressed(event) {
        prevx = event.x
        prevy = event.y
        if (root.state == "idle") {
            singletap.start();
            longtap.start();
            root.state = "initial";
        }
        if (root.state == "pending") {
            singletap.stop();
            state = "second";
        }
    }

    function handleMouseReleased(event) {
        if (root.state == "initial") {
            longtap.stop()
            singletap.start()
            root.state = "pending"
        }
        if (root.state == "second") {
            console.log("doubleTap")
            longtap.stop()
            doubleTap()
            root.state = "idle";
        }
        if (root.state == "long") {
            console.log("longTap")
            longTap();
            root.state = "idle";
        }
    }

    function handleMouseCanceled() {
        singletap.stop()
        longtap.stop()
        root.state="idle"
    }

    Timer {
        id: singletap; interval: 300; running: false; repeat: false;
        onTriggered: root.handleSingleTapTimeout()
    }

    Timer {
        id: longtap;   interval: 600; running: false; repeat: false;
        onTriggered: root.handleLongTapTimeout()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed:  root.handleMousePressed(mouse)
        onReleased: root.handleMouseReleased(mouse)
        onCanceled: root.handleMouseCanceled()
    }
}

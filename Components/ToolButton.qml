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

    signal clicked()
    signal repeat()

    signal shortPressed()
    signal longPressed()
    signal released()

    property int repeatcount: 0

    Timer {
        id: timer
        interval: 250; running: false; repeat: true
        onTriggered: {
            //console.log("ToolButton.timer.onTriggered")
            root.repeat()
            root.repeatcount += 1
            if (root.repeatcount == 3)
                longPressed()
        }
    }

    states: [
        State { name: "pressed";  PropertyChanges { target: timer; running: true }  PropertyChanges { target: root; scale: 0.9 } },
        State { name: "released";  PropertyChanges { target: timer; running: false } }
    ]

    function _pressed() {
        //console.log("ToolButton._pressed()")
        root.repeatcount = 0
        root.selected = true
        state = "pressed"
    }

    function _released() {
        //console.log("ToolButton._released()")
        root.selected = false
        state = "released"
        if (root.repeatcount<3)
            shortPressed()
        released()
    }

    MouseArea {
        id: mouseArea
        anchors.fill:  parent
        onClicked: root.clicked();
        onPressed: root._pressed()
        onCanceled: root._released()
        onReleased: root._released()
    }
}

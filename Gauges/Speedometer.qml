import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string name: "speed"
    property double current:  0
    property double average:  0
    property double minimum:  0
    property double maximum:  0
    property double distance: 0
    property double monitor:  0

    property int analogmode: 0  // 0: current; 1: average; 2: minimum; 3: maximum; 4: distance; 5: monitor
    property int topmode:    0
    property int bottommode: 3

    onCurrentChanged:      update()
    onAverageChanged:      update()
    onMinimumChanged:      update()
    onMaximumChanged:      update()
    onDistanceChanged:     update()
    onMonitorChanged:      update()
    onAnalogmodeChanged:   update()
    onTopmodeChanged:      update()
    onBottommodeChanged:   update()

    Component.onCompleted: update()

    function toFixed(num,count) {
        var s = num.toFixed(count).toString();
        return s;
    }

    property double analogvalue: 0
    property double topvalue: 0
    property double bottomvalue: 0

    function updateCurrent(value) {
        current = value;
    }

    function updateAverage(value) {
        average = value;
    }

    function updateMinimum(value) {
        minimum = value;
    }

    function updateMaximum(value) {
        maximum = value;
    }

    function updateDistance(value) {
        ascent = value;
    }

    function updateMonitor(value) {
        descent = value;
    }

    function update() {
        switch (analogmode)
        {
            case 0: analogvalue = current;  break;
            case 1: analogvalue = average;  break;
            case 2: analogvalue = minimum;  break;
            case 3: analogvalue = maximum;  break;
            case 4: analogvalue = distance; break;
            case 5: analogvalue = monitor;  break;
        }

        switch (topmode)
        {
            case 0: topvalue = current;  break;
            case 1: topvalue = average;  break;
            case 2: topvalue = minimum;  break;
            case 3: topvalue = maximum;  break;
            case 4: topvalue = distance; break;
            case 5: topvalue = monitor;  break;
        }

        switch (bottommode)
        {
            case 0: bottomvalue = current;  break;
            case 1: bottomvalue = average;  break;
            case 2: bottomvalue = minimum;  break;
            case 3: bottomvalue = maximum;  break;
            case 4: bottomvalue = distance; break;
            case 5: bottomvalue = monitor;  break;
        }
    }

    Image {
        source: ((analogvalue>10) || (maximum>10))? "speed200.png" : "speed10.png"
        width: parent.width
        height: parent.height

        Text {
            id: nametext
            anchors.horizontalCenter: parent.horizontalCenter
            y: parent.height * 0.3
            text: root.name;
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3* 0.18
            style: Text.Raised; styleColor: "black"
        }
    }

    Rectangle {
        y: parent.height * 0.75
        height: parent.height * 0.16
        color: "black"
        width: parent.width/4
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(topvalue,1)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
        Text {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(bottomvalue,1)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
    }

    Image {
        source: "speedneedle.png"
        width: parent.width
        height: parent.height
        transform: Rotation {
            id: needle
            origin.x: width/2
            origin.y: height/2
            angle: ((analogvalue<10) && (maximum<10))? analogvalue/10*360 -180: analogvalue/200*360 -180
        }
    }
}

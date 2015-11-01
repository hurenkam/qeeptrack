import QtQuick 2.5
import QtPositioning 5.2
import "qrc:/Components"

Item {
    id: root
    anchors.fill: parent

    property string name: "altitude (100m)"
    property double current: 0
    property double average: 0
    property double minimum: 0
    property double maximum: 0
    property double ascent:  0
    property double descent: 0

    property int analogmode: 0 // 0: current; 1: average; 2: minimum; 3: maximum; 4: ascent; 5: descent
    property int topmode:    2
    property int bottommode: 3
    property int divider: 100
    property int digits: 2

    onCurrentChanged:      update()
    onAverageChanged:      update()
    onMinimumChanged:      update()
    onMaximumChanged:      update()
    onAscentChanged:       update()
    onDescentChanged:      update()
    onAnalogmodeChanged:   update()
    onTopmodeChanged:      update()
    onBottommodeChanged:   update()

    Component.onCompleted: update()

    property int analogvalue: 0

    property int topvalue: 0
    property int bottomvalue: 0

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

    function updateAscent(value) {
        ascent = value;
    }

    function updateDescent(value) {
        descent = value;
    }

    function update() {
        switch (analogmode)
        {
            case 0: analogvalue = current; break;
            case 1: analogvalue = average; break;
            case 2: analogvalue = minimum; break;
            case 3: analogvalue = maximum; break;
            case 4: analogvalue = ascent;  break;
            case 5: analogvalue = descent; break;
        }

        switch (topmode)
        {
            case 0: topvalue = current; break;
            case 1: topvalue = average; break;
            case 2: topvalue = minimum; break;
            case 3: topvalue = maximum; break;
            case 4: topvalue = ascent;  break;
            case 5: topvalue = descent; break;
        }

        switch (bottommode)
        {
            case 0: bottomvalue = current; break;
            case 1: bottomvalue = average; break;
            case 2: bottomvalue = minimum; break;
            case 3: bottomvalue = maximum; break;
            case 4: bottomvalue = ascent;  break;
            case 5: bottomvalue = descent; break;
        }
    }

    function toFixed(num,count) {
        var s = num.toFixed(count).toString();
        return s;
    }

    Image {
        source: "speed10.png"
        anchors.fill: parent

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
            id: top
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(topvalue/divider,digits)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
        Text {
            id: bottom
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 2
            text: root.toFixed(bottomvalue/divider,digits)
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
    }

    Image {
        source: "shorthand.png"
        anchors.fill: parent
        transform: Rotation {
            id: shorthand
            origin.x: width/2
            origin.y: height/2
            angle: -180 + analogvalue/(100*divider) * 360
            Behavior on angle {
                id: shorthandanimation
                enabled: false
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }

    Image {
        source: "longhand.png"
        anchors.fill: parent
        transform: Rotation {
            id: longhand
            origin.x: width/2
            origin.y: height/2
            angle: -180 + analogvalue/(10*divider) * 360
            Behavior on angle {
                id: longhandanimation
                enabled: false
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }

    Image {
        source: "secondhand.png"
        anchors.fill: parent
        transform: Rotation {
            id: secondhand
            origin.x: width/2
            origin.y: height/2
            angle: -180 + analogvalue/divider * 360
            Behavior on angle {
                id: secondhandanimation
                enabled: false
                NumberAnimation {
                    duration: 1000
                }
            }
        }
    }
}

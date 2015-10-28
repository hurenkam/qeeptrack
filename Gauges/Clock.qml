import QtQuick 2.5

Item {
    id: root

    property variant layout: Item {}
    x: layout.x; y: layout.y; width: layout.width; height: layout.height

    property date current: new Date(0,0,0)
    property date elapsed: new Date(0,0,0)
    property date monitor: new Date(0,0,0)

    property int analogmode: 0  // 0: current; 1: elapsed; 2: monitor
    property int topmode:    1
    property int bottommode: 2

    onCurrentChanged:     update()
    onElapsedChanged:     update()
    onMonitorChanged:     update()
    onAnalogmodeChanged:  update()
    onTopmodeChanged:     update()
    onBottommodeChanged:  update()

    Component.onCompleted: update()

    property date analogvalue: new Date(0,0,0)
    property date topvalue:    new Date(0,0,0)
    property date bottomvalue: new Date(0,0,0)

    function update() {
        switch (analogmode)
        {
            case 0: analogvalue = current; break;
            case 1: analogvalue = elapsed; break;
            case 2: analogvalue = monitor; break;
        }

        switch (topmode)
        {
            case 0: topvalue = current; break;
            case 1: topvalue = elapsed; break;
            case 2: topvalue = monitor; break;
        }

        switch (bottommode)
        {
            case 0: bottomvalue = current; break;
            case 1: bottomvalue = elapsed; break;
            case 2: bottomvalue = monitor; break;
        }
    }

    Image {
        source: "clock.png";
        anchors.fill: parent
    }

    Rectangle {
        y: parent.height * 0.7
        height: parent.height * 0.18
        color: "black"
        width: parent.width/3.5
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: toptext
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(topvalue,"hh:mm:ss");
            color: "white"
            font.bold: true; font.pixelSize: parent.height/3
            style: Text.Raised; styleColor: "black"
        }
        Text {
            y: parent.height/2
            id: bottomtext
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(bottomvalue,"hh:mm:ss");
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
            angle: analogvalue.getHours()*360/12 +  analogvalue.getMinutes()/2
            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: .15
                    modulus: 360
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
            angle: analogvalue.getMinutes()*360/60
            Behavior on angle {
                SpringAnimation {
                    spring: 1.4
                    damping: .15
                    modulus: 360
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
            angle: analogvalue.getSeconds()*360/60
            Behavior on angle {
                SpringAnimation {
                    spring: 1.3
                    damping: .15
                    modulus: 360
                }
            }
        }
    }
}

import QtQuick 2.5

Item {
    id: root

    property alias leftButtonVisible:  leftbutton.visible
    property alias leftButtonSource:   leftbutton.source
    property alias leftButtonRadius:   leftbutton.bgradius
    property alias rightButtonVisible: rightbutton.visible
    property alias rightButtonSource:  rightbutton.source
    property alias rightButtonRadius:  rightbutton.bgradius
    property alias text:               label.text
    property real  buttonheight:       50

    signal leftClicked()
    signal rightClicked()

    Rectangle {
        id: rect
        anchors.fill: parent
        color: activePalette.light
        state: "normal"

        property QtObject normalgradient: Gradient {
            GradientStop {
                position: 0.0
                color: Qt.lighter(activePalette.light)
            }
            GradientStop {
                position:  1.0
                color: Qt.lighter(activePalette.dark)
            }
        }
        property QtObject pressedgradient: Gradient {
            GradientStop {
                position: 0.0
                color: activePalette.light
            }
            GradientStop {
                position:  1.0
                color: activePalette.dark
            }
        }
        gradient: state=="pressed"? pressedgradient : normalgradient

        ToolButton {
            id: leftbutton

            x: visible? 5 : 0
            y: visible? 5 : 0
            width:  visible? root.buttonheight -10 : 0
            height: visible? root.buttonheight -10 : 0

            visible: false
            bgcolor: "black"
            source: "back.png";
            onClicked: root.leftClicked();
        }

        Text {
            id: label
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -5
            text: ""
            //font.pixelSize: parent.height/2
            //font.pixelSize: screen.pixelSize
            font.pointSize: screen.pointSize
            color: "white"
            visible: (text!="")
        }

        ToolButton {
            id: rightbutton

            x: visible? parent.width - root.buttonheight +5 : parent.width
            y: visible? 5 : 0
            width:  visible? root.buttonheight -10 : 0
            height: visible? root.buttonheight -10 : 0

            visible: false
            source: "forward.png";
            bgcolor: "black"
            onClicked: root.rightClicked();
        }

        function clicked() {
            console.log("MenuEntry.clicked")
            if (leftbutton.visible && !rightbutton.visible) root.leftClicked()
            if (!leftbutton.visible && rightbutton.visible) root.rightClicked()
        }
        function pressed() {
            console.log("MenuEntry.pressed")
            if (leftbutton.visible && !rightbutton.visible) state = "pressed"
            if (!leftbutton.visible && rightbutton.visible) state = "pressed"
        }
        function released() {
            console.log("MenuEntry.released")
            state = "normal"
        }

        MouseArea {
            id: leftarea
            anchors.left: parent.left
            width: parent.width/2
            height: parent.height
            onClicked: root.leftClicked()
            onPressed:  { rect.state="pressed"; leftbutton.pressed();   }
            onCanceled: { rect.state="normal";  leftbutton.cancelled(); }
            onReleased: { rect.state="normal";  leftbutton.released();  }
        }
        MouseArea {
            id: rightarea
            anchors.right: parent.right
            height: parent.height
            width: parent.width/2
            onClicked: root.rightClicked()
            onPressed:  { rect.state="pressed"; rightbutton.pressed();   }
            onCanceled: { rect.state="normal";  rightbutton.cancelled(); }
            onReleased: { rect.state="normal";  rightbutton.released();  }
        }
    }
}

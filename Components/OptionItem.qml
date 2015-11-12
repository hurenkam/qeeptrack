import QtQuick 2.5

Item {
    id: root
    property alias button: btn.visible
    property alias buttonsource: btn.source
    property bool  hilite: (btn.state=="pressed")
    property color hilitecolor: "#c0c0e0"
    property int   index2: -1
    property bool  roundtop: false
    property bool  roundbottom: false
    property bool  underline: true

    signal clicked(int index, string name)

    Rectangle {
        id: hiliterect
        visible: root.hilite
        x: -9;               width:  parent.width +20
        y: 0;                height: parent.height
        color: root.hilitecolor
    }

    Rectangle {
        id: bottomline
        visible: (! roundbottom) && underline
        x: -9;               width:  parent.width +20
        //y: parent.height+9;  height: 1
        y: parent.height; height:1
        color: "grey"
    }

    ToolButton {
        id: btn

        x: root.width-txt.height
        y: 0
        width:  txt.height
        height: txt.height

        visible: false
        bgcolor: root.hilitecolor
        source: "forward.png";
        onClicked: {
            console.log("OptionItem.btn.onClicked: ",root.index2,root.text)
            root.clicked(root.index2,root.text);
        }
    }

    MouseArea {
        id: mouseArea
        visible: btn.visible
        anchors.fill:  parent
        onClicked:  if (btn.visible) btn.clicked()
        onPressed:  if (btn.visible) btn.pressed()
        onCanceled: if (btn.visible) btn.released()
        onReleased: if (btn.visible) btn.released()
    }
}

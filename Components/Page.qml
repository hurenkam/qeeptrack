import QtQuick 2.5

Rectangle {
    id: root
    color: "black"
    visible: false
    property alias imageSource: image.source

    signal pushed()
    signal popped()

    function pop() {
        popped()
    }

    function push() {
        pushed()
    }

    Image {
        id: image
        anchors.fill: parent
        visible: (source != "")
        source: ""
        fillMode: Image.Tile
    }

    property bool landscape: (width>height)
    property real h: (landscape)? height/375 : height/667
    property real w: (landscape)? width/667  : width/375

    property Item pageStack: null

    MouseHandler {
        anchors.fill: parent
    }
}

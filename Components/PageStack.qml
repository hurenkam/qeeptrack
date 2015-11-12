import QtQuick 2.5
import "PageStack.js" as JS

Rectangle {
    id: root
    color: "black"
    x: -pwidth
    y: 0
    width: 0
    height: parent.height
    property real pwidth: parent.width
    property real pheight: parent.height
    onPwidthChanged: resizeWidth()
    onPheightChanged: resizeHeight()
    property bool animate: false
    property int animationDuration: 300
    //property int platform: 0

    signal popLast()

    Behavior on x {
        enabled: root.animate
        NumberAnimation { easing.type: Easing.InOutQuart; duration: animationDuration }
    }

    Timer {
        id: disposeTimer;
        interval: animationDuration;
        repeat: false;
        onTriggered: delayedDispose()

        property Item oldpage: null

        function delayedDispose() {
            if (!oldpage) return;
            oldpage.parent = null;
            oldpage.visible = false;
        }

        function dispose(page) {
            oldpage = page;
            start();
        }
    }

    function resizeChildren() {
        resizeWidth()
        resizeHeight()
    }

    function resizeWidth() {
        for (var i=0;i<JS.length();i++) {
            JS.stack[i].x = i * parent.width;
            JS.stack[i].width = parent.width;
        }
        x = -(JS.length()-1)*parent.width
        width =  parent.width * JS.length()
    }

    function resizeHeight() {
        for (var i=0;i<JS.length();i++) {
            JS.stack[i].height = parent.height;
        }
        height = pheight
    }

    function push(page) {
        page.push()
        animate = true;
        JS.push(page);
        page.parent = root;
        page.pageStack = root;
        page.visible = true
        resizeChildren();
        animate = false;
    }

    function home() {
        while (JS.length() > 1) pop();
    }

    function pop() {
        animate = true;
        if (JS.length()<2) {
            popLast();
            return;
        }
        var oldpage = JS.pop();
        resizeChildren();
        animate = false;
        oldpage.pop()
        disposeTimer.dispose(oldpage);
    }
}

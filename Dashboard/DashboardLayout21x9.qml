import QtQuick 2.5

Item {
    id: root

    property var big: screen.shortside
    property var margin: 5
    property var bigwidth: big -2*margin

    Item {
        id: box
        property var tmp: (screen.longside - 2*big) + big/8
        width:  (tmp > screen.shortside)? screen.shortside : tmp
        height: width/2
        x: (screen.longside - width)/2
    }

    property variant current: screen.portrait? portrait: landscape
    property list<QtObject> portrait: [
        Item { y: box.x;                      x: margin;                       width: box.height-margin*2; height: width },
        Item { y: box.x+box.height+2*margin;  x: margin;                       width: box.height-margin*2; height: width },

        Item { y: margin;                     x: margin;                       width: bigwidth;            height: width },
        Item { y: screen.longside-big;        x: margin;                       width: bigwidth;            height: width },

        Item { y: box.x;                      x: screen.shortside-box.height;  width: box.height-margin*2; height: width },
        Item { y: box.x+box.height+2*margin;  x: screen.shortside-box.height;  width: box.height-margin*2; height: width }
    ]

    property list<QtObject> landscape: [
        Item { x: box.x;                      y: margin;                       width: box.height-margin*2; height: width },
        Item { x: box.x+box.height+2*margin;  y: margin;                       width: box.height-margin*2; height: width },

        Item { x: margin;                     y: margin;                       width: bigwidth;            height: width },
        Item { x: screen.longside-big;        y: margin;                       width: bigwidth;            height: width },

        Item { x: box.x;                      y: screen.shortside-box.height;  width: box.height-margin*2; height: width },
        Item { x: box.x+box.height+2*margin;  y: screen.shortside-box.height;  width: box.height-margin*2; height: width }
    ]
}


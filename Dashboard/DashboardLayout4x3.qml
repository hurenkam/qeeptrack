import QtQuick 2.5

Item {
    id: root

    property int shortside: (screen.width>screen.height)? screen.height: screen.width
    property int longside:  (screen.width<=screen.height)? screen.height: screen.width
    property int small: (shortside - big)
    property int big: longside/2
    property int margin: 5
    property int smallx: (longside - 4*small)/5

    property variant current: screen.portrait? portrait: landscape
    property list<QtObject> portrait: [
        Item { y: margin+smallx;            x: big+margin;  width: small-2*margin;  height: width },
        Item { y: margin+smallx*2+small;    x: big+margin;  width: small-2*margin;  height: width },
        Item { y: margin;                   x: margin;      width: big-2*margin;    height: width },
        Item { y: margin+smallx*3+small*2;  x: big+margin;  width: small-2*margin;  height: width },
        Item { y: margin+smallx*4+small*3;  x: big+margin;  width: small-2*margin;  height: width },
        Item { y: margin+big;               x: margin;      width: big-2*margin;    height: width }
    ]

    property list<QtObject> landscape: [
        Item { x: margin+smallx;            y: big+margin;  width: small-2*margin;  height: width },
        Item { x: margin+smallx*2+small;    y: big+margin;  width: small-2*margin;  height: width },
        Item { x: margin;                   y: margin;      width: big-2*margin;    height: width },
        Item { x: margin+smallx*3+small*2;  y: big+margin;  width: small-2*margin;  height: width },
        Item { x: margin+smallx*4+small*3;  y: big+margin;  width: small-2*margin;  height: width },
        Item { x: margin+big;               y: margin;      width: big-2*margin;    height: width }
    ]
}


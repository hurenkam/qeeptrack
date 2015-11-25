import QtQuick 2.5

Item {
    id: root

    property int margin: 5
    property int big:    (screen.shortside)
    property int medium: (screen.longside -big)/5 * 3
    property int small:  (screen.longside -big)/5 * 2

    property int bigwidth:    big    - 2*margin
    property int mediumwidth: medium - 2*margin
    property int smallwidth:  small  - 2*margin

    property int deltax:  (screen.longside  - big - medium - small)/4
    property int deltaym: (screen.shortside - medium*2)/3
    property int deltays: (screen.shortside - small*3)/4

    property variant current: screen.portrait? portrait: landscape
    property list<QtObject> portrait: [
        Item { y: margin+deltax;               x: margin+deltaym;                  width: mediumwidth;  height: width },
        Item { y: margin+deltax;               x: margin+deltaym*2+medium;         width: mediumwidth;  height: width },
        Item { y: margin+deltax*2+medium;      x: margin+deltaym;                  width: bigwidth;     height: width },
        Item { y: margin+deltax*3+medium+big;  x: margin+deltays;                  width: smallwidth;   height: width },
        Item { y: margin+deltax*3+medium+big;  x: margin+deltays*2+small;          width: smallwidth;   height: width },
        Item { y: margin+deltax*3+medium+big;  x: margin+deltays*3+small*2;        width: smallwidth;   height: width }
    ]

    property list<QtObject> landscape: [
        Item { x: margin+deltax;               y: margin+deltaym;                  width: mediumwidth;  height: width },
        Item { x: margin+deltax;               y: margin+deltaym*2+medium;         width: mediumwidth;  height: width },
        Item { x: margin+deltax*2+medium;      y: margin;                          width: bigwidth;     height: width },
        Item { x: medium+big-small/4;          y: margin+deltays;                  width: small+margin; height: width },
        Item { x: margin+deltax*3+medium+big;  y: margin+deltays*2+small;          width: smallwidth;   height: width },
        Item { x: medium+big-small/4;          y: margin+deltays*3+small*2;        width: small+margin; height: width }
    ]
}


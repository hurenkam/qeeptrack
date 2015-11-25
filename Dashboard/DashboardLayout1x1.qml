import QtQuick 2.5

Item {
    id: root

    property int realwidth: (screen.width>screen.height)? screen.height: screen.width
    property int margin: 5
    property int big: realwidth/3*2
    property int bigwidth: big -2*margin
    property int small: realwidth/3
    property int smallwidth: small -2*margin

    property int marginx: (screen.width - realwidth)/2 + margin
    property int marginy: (screen.height - realwidth)/2 + margin

    property list<QtObject> current: [
        Item { x: marginx+big;      y: marginy;          width: smallwidth;  height: width },
        Item { x: marginx+big;      y: marginy+small;    width: smallwidth;  height: width },
        Item { x: marginx;          y: marginy;          width: bigwidth;    height: width },
        Item { x: marginx;          y: marginy+small*2;  width: smallwidth;  height: width },
        Item { x: marginx+small;    y: marginy+small*2;  width: smallwidth;  height: width },
        Item { x: marginx+small*2;  y: marginy+small*2;  width: smallwidth;  height: width }
    ]
}


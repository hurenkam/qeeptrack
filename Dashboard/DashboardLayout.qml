import QtQuick 2.0

Item {
    id: root
    property int mode: 0
    property variant current: (mode == 0)? portrait: landscape

    property list<QtObject> portrait: [
        Item { x:  10; y:  15; width: 175; height: 175 },
        Item { x: 190; y:  15; width: 175; height: 175 },
        Item { x:  10; y: 180; width: 355; height: 355 },
        Item { x:  10; y: 525; width: 120; height: 120 },
        Item { x: 137; y: 545; width: 101; height: 101 },
        Item { x: 245; y: 525; width: 120; height: 120 }
    ]
    property list<QtObject> landscape: [
        Item { y:  10; x:  15; width: 175; height: 175 },
        Item { y: 190; x:  15; width: 175; height: 175 },
        Item { y:  10; x: 180; width: 355; height: 355 },
        Item { y:  10; x: 525; width: 120; height: 120 },
        Item { y: 137; x: 545; width: 101; height: 101 },
        Item { y: 245; x: 525; width: 120; height: 120 }
    ]
}

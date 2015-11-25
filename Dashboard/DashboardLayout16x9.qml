import QtQuick 2.5

Item {
    id: root

    property int realwidth: (screen.width>screen.height)? screen.height: screen.width
    property int minimummargin: 10
    property int bigdial: realwidth - 2*minimummargin
    property int mediumdial:   (realwidth - 3*minimummargin)/2
    property int smalldial:    (realwidth - 4*minimummargin)/3
    property int bigmargin:    (realwidth - bigdial)/2
    property int mediummargin: (realwidth - 2*mediumdial)/3
    property int smallmargin:  (realwidth - 3*smalldial)/4

    property variant current: screen.portrait? portrait: landscape
    property list<QtObject> portrait: [
        Item { x: mediummargin;              y: mediummargin;                     width: mediumdial; height: mediumdial },
        Item { x: mediummargin*2+mediumdial; y: mediummargin;                     width: mediumdial; height: mediumdial },
        Item { x: bigmargin;                 y: mediumdial;                       width: bigdial;    height: bigdial    },
        Item { x: smallmargin;               y: mediumdial+bigdial-smallmargin*2; width: smalldial;  height: smalldial  },
        Item { x: smallmargin*2+smalldial;   y: mediumdial+bigdial+smallmargin;   width: smalldial;  height: smalldial  },
        Item { x: smallmargin*3+smalldial*2; y: mediumdial+bigdial-smallmargin*2; width: smalldial;  height: smalldial  }
    ]

    property list<QtObject> landscape: [
        Item { y: mediummargin;              x: mediummargin;                     width: mediumdial; height: mediumdial },
        Item { y: mediummargin*2+mediumdial; x: mediummargin;                     width: mediumdial; height: mediumdial },
        Item { y: bigmargin;                 x: mediumdial;                       width: bigdial;    height: bigdial    },
        Item { y: smallmargin;               x: mediumdial+bigdial-smallmargin*2; width: smalldial;  height: smalldial  },
        Item { y: smallmargin*2+smalldial;   x: mediumdial+bigdial+smallmargin;   width: smalldial;  height: smalldial  },
        Item { y: smallmargin*3+smalldial*2; x: mediumdial+bigdial-smallmargin*2; width: smalldial;  height: smalldial  }
    ]
}


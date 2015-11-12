import QtQuick 2.0

Item {
    id: root
    property int mode: 0
    property variant current: screen.portrait? portrait: landscape
    property double widthscale: screen.widthscale
    property double heightscale: screen.heightscale
    property double scale: screen.scale

    property int realwidth: (width>height)? height: width
    property int minimummargin: 10
    property int bigdial: realwidth - 2*minimummargin
    property int mediumdial: (realwidth - 3*minimummargin)/2
    property int smalldial: (realwidth - 4*minimummargin)/3
    property int bigmargin: (realwidth - bigdial)/2
    property int mediummargin: (realwidth - 2*mediumdial)/3
    property int smallmargin: (realwidth - 3*smalldial)/4

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

    onWidthChanged: console.log("DashboardLayout.onWidthChanged: New width",width)
    onHeightChanged: console.log("DashboardLayout.onHeightChanged: New height",height)
}


/*
  iPhone resolutions:   Points      H/W     Rendered    Physical
  2G, 3G, 3GS:          320x480     1.5     320x480     320x480
  4, 4S:                320x480     1.5     640x960     640x960
  5, 5S:                320x568     1.775   640x1136    640x1136
  6, 6S Zoomed:         320x568     1.775   640x1136    750x1334
  6, 6S:                375x667     1.779   750x1334    750x1334
  6+, 6S+ Zoomed:       375x667     1.779   1125x2001   1080x1920
  6+, 6S+:              414x736     1.778   1242x2208   1080x1920
  (see the excellent overview here: http://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions)

  iPad resolutions:
  iPad                  768x1024    1.333
  iPad2                 768x1024
  iPad3                 1536x2048
  iPad4                 1536x2048
  iPad Air              1536x2048
  iPad Air 2            1536x2048
  iPad Mini             768x1024
  iPad Mini 2           1536x2048
  iPad Mini 3           1536x2048
  iPad Mini 4           1536x2048
  iPad Pro              2048x2732

  Android phone resolutions:
  HTC Evo 3D:           540x960     1.778
  Samsung Galaxy S2:    480x800     1.667
  Samsung Galaxy S3:    720x1280    1.778
  Samsung Galaxy S4:    1080x1920   1.778
  Samsung Galaxy S5:    1080x1920   1.778
  Samsung Galaxy S6:    1440x2560   1.778


  General Notes:
  ==============
  * Most recent phones seem to use a 1.78 ratio (==16:9). Exceptions: Galaxy S2 (==15:9), iPhone <5 (==3:2)
  * iPad ratio is 1.33 for all models (==4:3)
*/

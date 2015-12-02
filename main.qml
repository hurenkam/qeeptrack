import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import "qrc:/Dashboard"
import "qrc:/Components"

ApplicationWindow {
    id:root
    visible: true

    visibility: "FullScreen"
    width: 375
    height: 667

    title: qsTr("qeeptrack")

    Item {
        id: screen
        width: root.width
        height: root.height

        property var    mode:        4
        property bool   portrait:    (width<=height)
        property bool   landscape:   (width>height)
        property double widthscale:  (landscape)?  width/667: width/375
        property double heightscale: (portrait)?  height/667: height/375
        property double scale:       (widthscale>heightscale)? heightscale: widthscale
        property double pointSize:   18
        property int    shortside:   landscape? height: width
        property int    longside:    portrait? height: width
        property double buttonwidth: shortside/10

        property string optionitembordercolor: "grey"
        property string optiontextcolor: "black"
        property string optionradiobuttontickedimage: "qrc:/Components/ticked.png"
        property string optionradiobuttonuntickedimage: "qrc:/Components/unticked.png"
        property string optionlistcolor: "white"
        property string optionlistimage: "qrc:/Components/options-bg.png"
        property string optionpagecolor: "white"
        property string optionpagecancelimage: "qrc:/Gauges/backc.png"
        property string optionpageconfirmimage: "qrc:/Gauges/confirmc.png"
        property string optionmenuitemimage: "qrc:/Components/forward.png"

        function layout() {
            var small = portrait? width: height
            var big = portrait? height: width

            var divider = big/small
            if (divider >= 21/9)        // 2.333
                screen.mode = 5
            else if (divider >= 16/9)   // 1.777
                screen.mode = 4
            else if (divider >= 16/10)  // 1.6
                screen.mode = 3
            else if (divider >= 3/2)    // 1.333
                screen.mode = 2
            else if (divider >= 4/3)    // 1.5
                screen.mode = 1
            else
                screen.mode = 0
        }
    }

    MapView {
        id: mapview
        stack: pagestack
        onQuit: close()
    }

    PageStack {
        id: pagestack
        anchors.fill: parent
        animate: true
    }

    Item {
        id: activePalette
        property var light: "#444444"
        property var dark: "#222222"
        //property var highlight: ""
        //property var highlightedText: ""
        //property var mid: ""
        //property var midlight: ""
        //property var shadow: ""
        //property var text: ""
        //property var window: ""
        //property var windowText: ""
    }

    onWidthChanged: screen.layout()
    onHeightChanged: screen.layout()

    Component.onCompleted: {
        screen.layout()

        //pagestack.push(dashboard)
        pagestack.push(mapview)

        console.log("Screen.width: ", Screen.width)
        console.log("Screen.height: ", Screen.height)
        console.log("Screen.pixelDensity: ", Screen.pixelDensity)
        console.log("Screen.logicalPixelDensity: ", Screen.logicalPixelDensity)
        console.log("Screen.devicePixelRatio: ", Screen.devicePixelRatio)

        console.log("screen.width:", screen.width)
        console.log("screen.height:", screen.height)
        console.log("screen.portrait:", screen.portrait)
        console.log("screen.mode:", screen.mode)
/*
    iPad 3:

        qml: Screen.width:  768
        qml: Screen.height:  1024
        qml: Screen.pixelDensity:  5.196850393700786
        qml: Screen.logicalPixelDensity:  2.834645669291339
        qml: Screen.devicePixelRatio:  2

    iPhone 6s:

        qml: Screen.width:  375
        qml: Screen.height:  667
        qml: Screen.pixelDensity:  6.41732283464567
        qml: Screen.logicalPixelDensity:  2.834645669291339
        qml: Screen.devicePixelRatio:  2

    Macbook Retina:

        qml: Screen.width:  1440
        qml: Screen.height:  900
        qml: Screen.pixelDensity:  4.350393766123761
        qml: Screen.logicalPixelDensity:  2.834645669291339
        qml: Screen.devicePixelRatio:  2

    Hp EliteBook:

        qml: Screen.width:  1600
        qml: Screen.height:  900
        qml: Screen.pixelDensity:  2.833534055934698
        qml: Screen.logicalPixelDensity:  3.7795275590551185
        qml: Screen.devicePixelRatio:  1
*/
    }
}

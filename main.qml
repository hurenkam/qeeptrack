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
    property int realwidth: (width>height)? height: width
    property int buttonheight: realwidth/10
    property int buttonlarge: realwidth/7
    property int buttonmedium: realwidth/10
    property int buttonsmall: realwidth/15

    Item {
        id: screen
        width: root.width
        height: root.height

        property bool   portrait:    (width<=height)
        property bool   landscape:   (width>height)
        property double widthscale:  (landscape)?  width/667: width/375
        property double heightscale: (portrait)?  height/667: height/375
        property double scale:       (widthscale>heightscale)? heightscale: widthscale
        property double pointSize:   18
        property double buttonwidth: realwidth/10

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

    Component.onCompleted: {
        //pagestack.push(dashboard)
        pagestack.push(mapview)

        console.log("Screen.width: ", Screen.width)
        console.log("Screen.height: ", Screen.height)
        console.log("Screen.pixelDensity: ", Screen.pixelDensity)
        console.log("Screen.logicalPixelDensity: ", Screen.logicalPixelDensity)
        console.log("Screen.devicePixelRatio: ", Screen.devicePixelRatio)
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

*/
    }
}

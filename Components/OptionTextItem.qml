import QtQuick 2.5
import QtQuick.Window 2.2

OptionItem {
    property alias text: txt.text
    height: txt.height

    Text {
        id: txt
        color: "black"
        //font.bold: true
        font.pointSize: Screen.pixelDensity * 1.0;
        text: ""
    }
}

import QtQuick 2.5
import "qrc:/Components"

Transformer {
    id: root
    title: "UTM/WGS84"
    destination: "+proj=utm +zone=" + zone.toString() + ((south)?" +south":"") + " " + ellps + " " + datum + " " + extra
    digits: 0
    xname: "Easting"
    yname: "Northing"

    property int zone: 31
    property bool south: false
    property string ellps: "+ellps=WGS84"
    property string datum: "+datum=WGS84"
    property string extra: "+units=m +no_defs"

    inputbox: OptionBox {
            id: utmed50input
            title: "Go to UTM/WGS84 position:"

            OptionTextEdit {
                title: "Zone"
                value: root.zone.toString()+hemisphere
                property var hemisphere: (map.center.latitude < 0)? "S": "N"
            }
            OptionTextEdit {
                title: "Northing"
                value: root.forwarded.y.toFixed(root.digits).toString()
            }
            OptionTextEdit {
                title: "Easting"
                value: root.forwarded.x.toFixed(root.digits).toString()
            }
        }
}

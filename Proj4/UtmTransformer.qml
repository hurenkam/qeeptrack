import QtQuick 2.5
import Proj4 1.0
import "qrc:/Components"

Transformer {
    id: root
    title: "UTM"
    destination: "+proj=utm +zone=" + zone.toString() + ((south)?" +south":"") + " " + ellps + " " + datum + " " + extra
    digits: 0
    xname: "E"
    yname: "N"

    property int zone: 31
    property bool south: false
    property string ellps: "+ellps=WGS84"
    property string datum: "+datum=WGS84"
    property string extra: "+units=m +no_defs"

    inputbox: OptionBox {
            title: "Go to " + root.title + " position:"

            function getCoordinate() {
                var input = zoneinput.value
                if (input.substring(input.length-1,1) =="S") {
                    input = input.substring(0,length-2)
                    root.south = true
                }
                if (input.substring(input.length-1,1) =="N") {
                    input = input.substring(0,length-2)
                    root.south = false
                }
                root.zone = parseInt(input)
                var northing = parseFloat(northinput.value)
                var easting = parseFloat(eastinput.value)
                console.log("UtmTransformer.getCoordinate() input:",root.title,root.zone,(root.south? "S":"N"),northing,easting)

                var p4c = Proj4.coordinate(easting,northing,0)
                var result = root.inverse(p4c)

                console.log("UtmTransformer.getCoordinate() result:",result.latitude,result.longitude)
                return result
            }

            OptionTextEdit {
                id: zoneinput
                title: "Zone"
                value: root.zone.toString()+hemisphere
                property var hemisphere: (map.center.latitude < 0)? "S": "N"
            }
            OptionTextEdit {
                id: northinput
                title: "Northing"
                value: root.forwarded.y.toFixed(root.digits).toString()
            }
            OptionTextEdit {
                id: eastinput
                title: "Easting"
                value: root.forwarded.x.toFixed(root.digits).toString()
            }
        }
}

import QtQuick 2.5
import QtQuick.Layouts 1.2
import Proj4 1.0
import "qrc:/Components"

Proj4Transformer {
    id: root
    title: "WGS84"
    destination: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
    digits: 5
    xname: "Longitude"
    yname: "Latitude"
    islatlon: true
    property int datumformat: 0
    onForwardedChanged: {
        switch (datumformat)
        {
            //text: "DDD.DDDDD°"
            case 0: {
                forwardedx = forwarded.x.toFixed(digits).toString()+"°"
                forwardedy = forwarded.y.toFixed(digits).toString()+"°"
                break;
            }
            //text: "DDD° MM.MMM'"
            case 1: {
                var dx = Math.floor(forwarded.x)
                var mx = (forwarded.x - dx) * 60
                var dy = Math.floor(forwarded.y)
                var my = (forwarded.y - dy) * 60
                forwardedx = dx.toString()+"°"+mx.toFixed(digits-2).toString()+"'"
                forwardedy = dy.toString()+"°"+my.toFixed(digits-2).toString()+"'"
                break;
            }
            //text: "DDD° MM' SS.S\""
            case 2: {
                var dx = Math.floor(forwarded.x)
                var mx = (forwarded.x - dx) * 60
                var sx = (mx - Math.floor(mx)) * 60
                var dy = Math.floor(forwarded.y)
                var my = (forwarded.y - dy) * 60
                var sy = (my - Math.floor(my)) * 60
                forwardedx = dx.toString()+"°"+Math.floor(mx).toString()+"'"+sx.toFixed(digits-4)+"\""
                forwardedy = dy.toString()+"°"+Math.floor(my).toString()+"'"+sy.toFixed(digits-4)+"\""
                break;
            }
        }
    }


    inputbox: OptionBox {
            id: wgs84input
            title: "Go to WGS84 position:"

            function getDegrees(value) {
                var i = value.indexOf("°")
                var s = value.substring(0,i)
                return parseFloat(s)
            }

            function getMinutes(value) {
                var i = value.indexOf("°")
                var j = value.indexOf("'")
                if ((i<0) || (j<0))
                    return 0

                var s = value.substring(i+1,j)
                return parseFloat(s)
            }

            function getSeconds(value) {
                var i = value.indexOf("'")
                var j = value.indexOf("\"")
                if ((i<0) || (j<0))
                    return 0

                var s = value.substring(i+1,j)
                return parseFloat(s)
            }

            function getCoordinate() {
                var latd = getDegrees(latitudeinput.value)
                var latm = getMinutes(latitudeinput.value)
                var lats = getSeconds(latitudeinput.value)
                var latitude = latd + latm/60 + lats/3600

                var lond = getDegrees(longitudeinput.value)
                var lonm = getMinutes(longitudeinput.value)
                var lons = getSeconds(longitudeinput.value)
                var longitude = lond + lonm/60 + lons/3600

                var p4c = Proj4.coordinate(longitude,latitude,0)
                var result = root.inverse(p4c)

                console.log("Wgs84Transformer.getCoordinate()",result.latitude,result.longitude)
                return result
            }

            OptionTextEdit {
                id: latitudeinput
                title: "Latitude"
                value: root.forwardedy
            }
            OptionTextEdit {
                id: longitudeinput
                title: "Longitude"
                value: root.forwardedx
            }
        }
}

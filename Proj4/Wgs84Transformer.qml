import QtQuick 2.5
import Proj4 1.0
import "qrc:/Components"

Transformer {
    id: root
    title: "WGS84"
    destination: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
    digits: 8
    xname: "Longitude"
    yname: "Latitude"

    inputbox: OptionBox {
            id: wgs84input
            title: "Go to WGS84 position:"

            function getCoordinate() {
                var latitude = parseFloat(latitudeinput.value)
                var longitude = parseFloat(longitudeinput.value)
                var p4c = Proj4.coordinate(longitude,latitude,0)
                var result = root.inverse(p4c)

                console.log("Wgs84Transformer.getCoordinate()",result.latitude,result.longitude)
                return result
            }

            OptionTextEdit {
                id: latitudeinput
                title: "Latitude"
                value: root.forwarded.y.toFixed(root.digits).toString()
            }
            OptionTextEdit {
                id: longitudeinput
                title: "Longitude"
                value: root.forwarded.x.toFixed(root.digits).toString()
            }
        }
}

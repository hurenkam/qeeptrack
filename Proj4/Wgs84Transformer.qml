import QtQuick 2.5
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

            OptionTextEdit {
                title: "Latitude"
                value: root.forwarded.y.toFixed(root.digits).toString()
            }
            OptionTextEdit {
                title: "Longitude"
                value: root.forwarded.x.toFixed(root.digits).toString()
            }
        }
}

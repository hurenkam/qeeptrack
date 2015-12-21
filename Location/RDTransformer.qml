import QtQuick 2.5
import Proj4 1.0
import "qrc:/Components"

Proj4Transformer {
    id: root
    title: "RD"
    destination: "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.4171,50.3319,465.5524,-0.398957388243134,0.343987817378283,-1.87740163998045,4.0725 +units=m +no_defs"
    xname: "X"
    yname: "Y"

    inputbox: OptionBox {
            id: rdinput
            title: "Go to RD position:"

            function getCoordinate() {
                var x = parseFloat(xinput.value)
                var y = parseFloat(yinput.value)
                var p4c = Proj4.coordinate(x,y,0)
                var result = root.inverse(p4c)

                console.log("RDTransformer.getCoordinate()",result.latitude,result.longitude)
                return result
            }

            OptionTextEdit {
                id: xinput
                title: "X"
                value: root.forwardedx
            }
            OptionTextEdit {
                id: yinput
                title: "Y"
                value: root.forwardedy
            }
        }
}

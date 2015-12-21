import QtQuick 2.5
import QtPositioning 5.5
import QtLocation 5.5
import QtQuick.Layouts 1.2
import "qrc:/Components"

Transformer {
    id: root
    title: "Address"

    onCoordinateChanged: outputtimer.start()

    Timer {
        id: outputtimer
        interval: 5000;
        running: false;
        repeat: false;
        triggeredOnStart: true;

        onTriggered: {
            outputmodel.query = root.coordinate
            outputmodel.update()
        }
    }

    GeocodeModel {
        id: outputmodel
        plugin: map.plugin
        property var address

        onAddressChanged: {
            if (address) {
                console.log("Found address: ",address.text)
                streettext.text = address.street
                citytext.text = address.city
                countrytext.text = address.country
            }
            else
            {
                streettext.text = ""
                citytext.text = ""
                countrytext.text = ""
            }
        }

        onStatusChanged: {
            if (status == GeocodeModel.Error)
                console.log("AddressTransformer.outputmodel.onStatusChanged:",errorString)
        }
        onLocationsChanged:
        {
            if (count >= 1) {
                address = get(0).address
            }
        }
    }

    GeocodeModel {
        id: inputmodel
        plugin: map.plugin
        property var coordinate
        property var callback

        onStatusChanged: {
            switch (status) {
                case GeocodeModel.Error:
                    console.log("AddressTransformer.inputmodel.onStatusChanged: Error:",errorString)
                    callback()
                    break;
            }
        }

        onLocationsChanged:
        {
            console.log("AddressTransformer.inputmodel.onLocationsChanged: Count:",count)
            if (count >= 1) {
                coordinate = get(0).coordinate
            }
            if (callback)
                callback()
        }
    }

    Address {
        id: inputaddress
        street: streetinput.value
        city: cityinput.value
        country: countryinput.value
    }

    inputbox: OptionBox {
            title: "Go to " + root.title + ":"

            function confirm(callback) {
                inputmodel.callback = callback
                inputmodel.query = inputaddress
                inputmodel.update()
            }

            function getCoordinate() {
                return inputmodel.coordinate
            }

            OptionTextEdit {
                id: streetinput
                title: "Street"
                value: streettext.text
            }
            OptionTextEdit {
                id: cityinput
                title: "City"
                value: citytext.text
            }
            OptionTextEdit {
                id: countryinput
                title: "Country"
                value: countrytext.text
            }
        }

    outputbox: ColumnLayout {
            x: 15
            y: 15
            width: parent.width-30
            height: parent.height-30

            Text {
                text: root.title
                color: "black"
                font.bold: true; font.pointSize: screen.pointSize *0.7
                style: Text.Raised; styleColor: "white"
                //Layout.columnSpan: 2
            }
            Text {
                id: streettext
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.5
                style: Text.Raised; styleColor: "white"
            }
            Text {
                id: citytext
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.5
                style: Text.Raised; styleColor: "white"
            }
            Text {
                id: countrytext
                color: "black"
                font.bold: false; font.pointSize: screen.pointSize*0.5
                style: Text.Raised; styleColor: "white"
            }
        }
}

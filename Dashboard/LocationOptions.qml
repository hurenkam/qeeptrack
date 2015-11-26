import QtQuick 2.0
import "qrc:/Components"

OptionsPage {
    id: root

    property var datumbox
    property string prefix: "qeeptrack.locationoptions."

    function confirm() {
        pagestack.pop()
    }

    SettingsDatabase {
        id: settings
        filename: "qeeptrack"
        prefix: root.prefix

        Component.onCompleted: root.loadSettings()
    }

    function loadSettings() {
        console.log("LocationOptions.loadSettings")
    }

    function saveSettings() {
        console.log("LocationOptions.loadSettings")
    }

    OptionList {
        id: options
        x: 10
        y: 20 + screen.buttonwidth
        width:  parent.width - 20
        height: parent.height -30 -screen.buttonwidth

        Component.onCompleted: dumpinfo()
        onXChanged: dumpinfo()
        onYChanged: dumpinfo()
        onWidthChanged: dumpinfo()
        onHeightChanged: dumpinfo()

        function dumpinfo() {
            console.log("LocationOptions.options.dumpinfo()",x,y,width,height,items.length)
        }
    }
    property var oldbox
    onDatumboxChanged: {
        console.log("LocationOptions.onDatumboxChanged()",datumbox.title)
        if (oldbox)
            oldbox.parent = null
        oldbox = datumbox
        options.addBox(datumbox)
    }
}

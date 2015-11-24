import QtQuick 2.0
import "qrc:/Components"


MapOptionsPage {
    id: root

    property int selecteddatum: 0
    property int selectedmap: 0
    property var maptypes
    property var datums
    property string prefix: "qeeptrack.mapoptions."

    function confirm() {
        root.selecteddatum = internal.selecteddatum
        root.selectedmap = internal.selectedmap
        pagestack.pop()
    }

    SettingsDatabase {
        id: settings
        filename: "qeeptrack"
        prefix: root.prefix

        Component.onCompleted: root.loadSettings()
    }

    function loadSettings() {
        selecteddatum = settings.getValue("datum","0")
        selectedmap = settings.getValue("maptype","0")
        console.log("MapOptions.loadSettings", selecteddatum,selectedmap)
    }

    function saveSettings() {
        settings.setValue("datum",selecteddatum.toString())
        settings.setValue("maptype",selectedmap.toString())
    }

    onPushed: {
        internal.selecteddatum = root.selecteddatum
        internal.selectedmap = root.selectedmap
    }

    Item {
        id: internal
        signal datumUpdate(int value)
        signal mapUpdate(int value)

        property int selecteddatum: root.selecteddatum
        property int selectedmap: root.selectedmap

        onSelecteddatumChanged: datumUpdate(selecteddatum)
        onSelectedmapChanged: mapUpdate(selectedmap)
    }

    MapOptionList {
        id: options
        x: 10
        y: 20 + screen.buttonwidth
        width:  parent.width - 20
        height: parent.height -30 -screen.buttonwidth

        MapOptionBox {
            id: mapselection
            title: "Map Type"

            function updateTicked(value) {
                console.log("MapOptions.MapOptionBox.updateTicked()",value)
                internal.selectedmap = value
            }

            function populate() {
                //console.log("MapOptions.MapOptionBox.populate()")
                for (var i=0; i<maptypes.length; i++)
                {
                    //console.log("MapOptions.MapOptionBox.populate()", maptypes[i].description)
                    var component = Qt.createComponent("qrc:/Dashboard/MapOptionRadioButton.qml");
                    var result = component.createObject(mapselection.columnlayout, {
                        text: maptypes[i].name,
                        index: i,
                        selected: internal.selectedmap
                    } );
                    result.ticked.connect(updateTicked)
                    internal.mapUpdate.connect(result.updateSelected)
                }
            }
        }

        MapOptionBox {
            id: datumselection
            title: "Datum"

            property int selected: 0
            function updateTicked(value) {
                console.log("MapOptions.datumselection.updateTicked()",value)
                internal.selecteddatum = value
            }

            function populate() {
                console.log("MapOptions.datumselection.populate()")
                for (var i=0; i<datums.length; i++)
                {
                    console.log("MapOptions.datumselection.populate()", datums[i].title)
                    var component = Qt.createComponent("qrc:/Dashboard/MapOptionRadioButton.qml");
                    var result = component.createObject(datumselection.columnlayout, {
                        text: datums[i].title,
                        index: i,
                        selected: internal.selecteddatum
                    } );
                    result.ticked.connect(updateTicked)
                    internal.datumUpdate.connect(result.updateSelected)
                }
            }
        }
/*
        MapOptionRadioBox {
            id: _mapselectionbox
            title: "Map Type"

            MapOptionRadioButton {
                id: _mapselection1
                text: "button1"
            }

            MapOptionRadioButton {
                id: _mapselection2
                text: "button2"
            }
        }
*/
        Component.onCompleted: {
            mapselection.populate()
            datumselection.populate()
        }
    }
}

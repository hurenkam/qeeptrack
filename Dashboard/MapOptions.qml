import QtQuick 2.0
import QtQuick.Layouts 1.1
import "qrc:/Components"

OptionsPage {
    id: root

    property int selecteddatum: 0
    property int selectedmap: 0
    property int selectedformat: 0
    property var maptypes
    property var datums
    property string prefix: "qeeptrack.mapoptions."

    function confirm() {
        root.selecteddatum = internal.selecteddatum
        root.selectedmap = internal.selectedmap
        root.selectedformat = internal.selectedformat
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
        selectedformat = settings.getValue("datumformat","0")
        console.log("MapOptions.loadSettings", selecteddatum,selectedmap,selectedformat)
    }

    function saveSettings() {
        settings.setValue("datum",selecteddatum.toString())
        settings.setValue("maptype",selectedmap.toString())
        settings.setValue("datumformat",selectedformat.toString())
    }

    onPushed: {
        internal.selecteddatum = root.selecteddatum
        internal.selectedmap = root.selectedmap
        internal.selectedformat = root.selectedformat
    }

    Item {
        id: internal
        signal datumUpdate(int value)
        signal mapUpdate(int value)
        signal formatUpdate(int value)

        property int selecteddatum:  root.selecteddatum
        property int selectedmap:    root.selectedmap
        property int selectedformat: root.selectedformat

        onSelecteddatumChanged:  datumUpdate(selecteddatum)
        onSelectedmapChanged:    mapUpdate(selectedmap)
        onSelectedformatChanged: formatUpdate(selectedmap)
    }

    OptionList {
        id: options
        x: 10
        y: 20 + screen.buttonwidth
        width:  parent.width - 20
        height: parent.height -30 -screen.buttonwidth

        OptionBox {
            id: mapselection
            title: "Map Type"
            Layout.rowSpan: 2

            function updateTicked(value) {
                console.log("MapOptions.OptionBox.updateTicked()",value)
                internal.selectedmap = value
            }

            function populate() {
                //console.log("MapOptions.MapOptionBox.populate()")
                for (var i=0; i<maptypes.length; i++)
                {
                    //console.log("MapOptions.OptionBox.populate()", maptypes[i].description)
                    var component = Qt.createComponent("qrc:/Components/OptionRadioButton.qml");
                    var result = component.createObject(mapselection.columnlayout, {
                        text: maptypes[i].name,
                        index: i,
                        selected: internal.selectedmap,
                    } );
                    result.ticked.connect(updateTicked)
                    internal.mapUpdate.connect(result.updateSelected)
                }
            }
        }

        OptionBox {
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
                    var component = Qt.createComponent("qrc:/Components/OptionRadioButton.qml");
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

        OptionBox {
            id: degreeformatselection
            title: "Datum Format"
            visible: root.datums[internal.selecteddatum].islatlon
            property int selected: 0

            OptionRadioButton {
                text: "DDD.DDDDD°"
                index: 0
                selected: internal.selectedformat
                onTicked: internal.selectedformat=index
            }
            OptionRadioButton {
                text: "DDD° MM.MMM'"
                index: 1
                selected: internal.selectedformat
                onTicked: internal.selectedformat=index
            }
            OptionRadioButton {
                text: "DDD° MM' SS.S\""
                index: 2
                selected: internal.selectedformat
                onTicked: internal.selectedformat=index
            }
        }

        Component.onCompleted: {
            mapselection.populate()
            datumselection.populate()
        }
    }
}

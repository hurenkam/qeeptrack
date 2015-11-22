import QtQuick 2.0
import "qrc:/Components"

Page {
    id: root
    anchors.fill: parent
    color: "white"

    property string title: "Options"
    property int selecteddatum: 0
    property int selectedmap: 0
    property var maptypes
    property var datums
    property string prefix: "qeeptrack.mapoptions."

    function cancel() {
        pagestack.pop();
    }

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
        console.log("MapOptions.onPushed")
        internal.selecteddatum = root.selecteddatum
        internal.selectedmap = root.selectedmap
    }

    onPopped: {
        console.log("MapOptions.onPopped")
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

    Item {
        x: 20 + buttonwidth
        y: 10
        width: parent.width - 2* (20+buttonwidth)
        height: buttonwidth

        Text {
            anchors.centerIn: parent
            id: titlewidget
            font.bold: true
            font.pointSize: screen.pointSize*10/8
            text: root.title
        }
    }

    MapOptionList {
        id: options
        x: 10
        y: 20 + buttonwidth
        width:  parent.width - 20
        height: parent.height -30 -buttonwidth

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

        Component.onCompleted: {
            mapselection.populate()
            datumselection.populate()
        }
    }

    ToolButton {
        id: leftbutton
        x: 10; y:10
        width: buttonwidth
        height: width

        bgcolor: "white"
        source: "qrc:/Gauges/backc.png";
        onClicked: {
            console.log("MapOptions.onCancel")
            root.cancel();
        }
    }

    ToolButton {
        id: rightbutton

        x: root.width - 10 -buttonwidth; y:10
        width: buttonwidth
        height: width

        source: "qrc:/Gauges/confirmc.png";
        bgcolor: "white"

        onClicked: {
            console.log("MapOptions.onConfirm")
            root.confirm();
            saveSettings()
        }
    }
}

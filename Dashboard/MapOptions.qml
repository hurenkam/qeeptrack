import QtQuick 2.0
import QtQuick.Layouts 1.1
import "qrc:/Components"

OptionsPage {
    id: root

    property int selectedtransformer: 0
    property int selectedmap: 0
    property int selectedformat: 0
    property var maptypes
    property var transformers
    property string prefix: "qeeptrack.mapoptions."

    function confirm() {
        root.selectedtransformer = internal.selectedtransformer
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
        selectedtransformer = settings.getValue("transformer","0")
        selectedmap = settings.getValue("maptype","0")
        selectedformat = settings.getValue("transformerformat","0")
        console.log("MapOptions.loadSettings", selectedtransformer,selectedmap,selectedformat)
    }

    function saveSettings() {
        settings.setValue("transformer",selectedtransformer.toString())
        settings.setValue("maptype",selectedmap.toString())
        settings.setValue("transformerformat",selectedformat.toString())
    }

    onPushed: {
        internal.selectedtransformer = root.selectedtransformer
        internal.selectedmap = root.selectedmap
        internal.selectedformat = root.selectedformat
    }

    Item {
        id: internal
        signal transformerUpdate(int value)
        signal mapUpdate(int value)
        signal formatUpdate(int value)

        property int selectedtransformer:  root.selectedtransformer
        property int selectedmap:    root.selectedmap
        property int selectedformat: root.selectedformat

        onSelectedtransformerChanged:  transformerUpdate(selectedtransformer)
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
            id: transformerselection
            title: "Transformer"

            property int selected: 0
            function updateTicked(value) {
                console.log("MapOptions.transformerselection.updateTicked()",value)
                internal.selectedtransformer = value
            }

            function populate() {
                console.log("MapOptions.transformerselection.populate()")
                for (var i=0; i<transformers.length; i++)
                {
                    console.log("MapOptions.transformerselection.populate()", transformers[i].title)
                    var component = Qt.createComponent("qrc:/Components/OptionRadioButton.qml");
                    var result = component.createObject(transformerselection.columnlayout, {
                        text: transformers[i].title,
                        index: i,
                        selected: internal.selectedtransformer
                    } );
                    result.ticked.connect(updateTicked)
                    internal.transformerUpdate.connect(result.updateSelected)
                }
            }
        }

        OptionBox {
            id: degreeformatselection
            title: "Format"
            visible: root.transformers[internal.selectedtransformer].islatlon
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
            transformerselection.populate()
        }
    }
}

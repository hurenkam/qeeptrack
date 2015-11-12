import QtQuick 2.5

DynamicItemModel {
    id: root
    name: ""
    property int ticked: -1

    //Settings { id: settings }

    onTickedChanged: {
        //console.log("onTickedChanged",count(),ticked)
        if (name != "") settings.setProperty(name,ticked)
        for (var i=0; i<root.count(); i++) {
            console.log("found radiobox item:", get(i))
            get(i).ticked = (ticked == i)
        }
    }

    Component.onCompleted: {
        ticked = (name != "")? settings.getProperty(name,0) : -1
    }
}

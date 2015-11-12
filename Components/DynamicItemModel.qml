//DynamicItemModel.qml
import QtQuick 2.5
import "DynamicList.js" as JList

Item {
    id: root
    property variant list: JList.getList()
    property string name

    signal listAppended()
    signal childrenMoved(int count)
    signal listCleared()

    function get(index) {
        return JList.getItem(index)
    }
    function append(item) {
        JList.addItem(item)
        listAppended()
    }
    function count() {
        return JList.count()
    }
    function movechildren() {
        var length = children.length
        if (length<1) return;
        for (var i=0; i<length; i++) {
            console.log("DynamicItemModel.movechildren",children,children[i])
            append(children[i])
        }
        childrenMoved(length)
    }
    function clear() {
        JList.clear()
        listCleared()
    }

    Component.onCompleted: {
        //console.log("DynamicItemModel has",children.length,"child(ren)")
        movechildren()
    }
}

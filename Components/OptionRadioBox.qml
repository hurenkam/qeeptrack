import QtQuick 2.0
import QtQuick.Layouts 1.1

OptionBox {
    id: root
    property int selectedButton

    signal selectedButtonUpdated(int value)

    function updateSelectedButton(value) {
        console.log("OptionRadioBox.updateSelectedButton()",title,value)
        selectedButton = value
        selectedButtonUpdated(value)
    }

    default property alias _tempcontent: _temp.children
    Item { id: _temp }
    property var content: []
    on_TempcontentChanged: move()

    function move() {
        if (_tempcontent.length === 0)
            return

        for (var i=0; i<_tempcontent.length; i++) {
            if (_tempcontent[i])
                addButton(_tempcontent[i])
        }
        contentChanged()
    }

    function addButton(value) {
        console.log("OptionRadioBox.addButton",value.text)
        content.push(value)
        value.ticked.connect(updateSelectedButton)
        root.selectedButtonUpdated.connect(value.updateSelected)
        value.parent = column
    }

    onContentChanged: layout()
    function layout() {
        console.log("OptionRadioBox.layout() length:",content.length,root.x,root.y,root.width,root.height)
        for (var i=0; i<content.length; i++) {
            if (content[i]) {
                content[i].index = i
                content[i].parent = column
            }
        }

        updateSelectedButton(root.selectedButton)
    }

    ColumnLayout {
        id: column
        x: 0
        y: 10 + titleheight
        width: parent.width
        spacing: 0
    }
}


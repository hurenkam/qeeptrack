import QtQuick 2.5

OptionTextItem {
    id: root
    property bool ticked: false
    button: true
    buttonsource: ticked? "ticked.png" : "unticked.png"
}

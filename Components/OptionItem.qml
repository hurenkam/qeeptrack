import QtQuick 2.5
import QtQuick.Layouts 1.1

Item {
    default property alias items: container.children
    Layout.preferredHeight: childrenRect.height+2
    Layout.fillWidth: true

    Item {
        id: container
        x: 10
        y: 2
        width: parent.width-20
        height: childrenRect.height
    }
}

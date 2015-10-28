import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

Item {
    width: 768
    height: 1280

    property alias button1: button1
    property alias button2: button2

    RowLayout {
        anchors.centerIn: parent
    }
}


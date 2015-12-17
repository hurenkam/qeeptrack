import QtQuick 2.0

Item {
    id: root
    property string title
    property string gaugetype: "compass"
    property double value
    property string units

    Behavior on value {
        SpringAnimation {
            spring: 1.4
            damping: .15
            modulus: 360
        }
    }
}

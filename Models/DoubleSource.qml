import QtQuick 2.0

Item {
    id: root
    property string title
    property string name
    property double value
    property string units
    property alias  duration: valueanimation.duration

    Behavior on value {
        enabled: (valueanimation.duration > 0)
        NumberAnimation {
            id: valueanimation
            duration: 1100
        }
    }
}

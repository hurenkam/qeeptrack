TEMPLATE = app

QT += qml quick widgets positioning svg location sensors

ios {
    QMAKE_INFO_PLIST = Info.plist
}

SOURCES += main.cpp \
    satellitemodel.cpp

RESOURCES += \
    qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    satellitemodel.h


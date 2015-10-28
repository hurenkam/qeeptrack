#include <QApplication>
#include <QQmlApplicationEngine>
#include "satellitemodel.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<SatelliteModel>("Local", 1, 0, "SatelliteModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}


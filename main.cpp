#include <QApplication>
#include <QQmlApplicationEngine>
#include "satellitemodel.h"
#include "projection.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<SatelliteModel>("Local", 1, 0, "SatelliteModel");
    qmlRegisterType<Projection>("Proj4", 1, 0, "Projection");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}


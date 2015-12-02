#include <QApplication>
#include <QQmlApplicationEngine>
#include "satellitemodel.h"
#include "projection.h"

QObject *p4singletonprovider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    return new P4Singleton();
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<SatelliteModel>("Local", 1, 0, "SatelliteModel");
    qmlRegisterSingletonType<P4Singleton>("Proj4", 1, 0, "Proj4", p4singletonprovider);
    qRegisterMetaType<P4Coordinate>("P4Coordinate");
    qRegisterMetaType<P4Projection>("P4Projection");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

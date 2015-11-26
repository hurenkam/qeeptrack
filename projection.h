#ifndef PROJ4PROJECTION_H
#define PROJ4PROJECTION_H

#include <QObject>
#include <QString>
#include <QGeoCoordinate>
#include <projects.h>

class Projection: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title      READ title      WRITE setTitle      NOTIFY titleChanged)
    Q_PROPERTY(QString xname      READ xName      WRITE setXName      NOTIFY xNameChanged)
    Q_PROPERTY(QString yname      READ yName      WRITE setYName      NOTIFY yNameChanged)
    Q_PROPERTY(QString definition READ definition WRITE setDefinition NOTIFY definitionChanged)

    Q_PROPERTY(QGeoCoordinate coordinate READ coordinate WRITE setCoordinate NOTIFY coordinateChanged)

    Q_PROPERTY(double  x  READ x  NOTIFY transformed)
    Q_PROPERTY(double  y  READ y  NOTIFY transformed)
    Q_PROPERTY(double  z  READ z  NOTIFY transformed)

    Q_PROPERTY(bool    isLatLong  READ isLatLong  NOTIFY definitionChanged)
    Q_PROPERTY(bool    isGeoCent  READ isGeoCent  NOTIFY definitionChanged)
    Q_PROPERTY(double  fromMeter  READ fromMeter  NOTIFY definitionChanged)
    Q_PROPERTY(double  toMeter    READ toMeter    NOTIFY definitionChanged)

public:
    QString definition() const;
    void setDefinition(QString value);

    QString title() const;
    void setTitle(QString value);

    QGeoCoordinate coordinate() const;
    void setCoordinate(QGeoCoordinate value);

    double x() const;
    double y() const;
    double z() const;

    QString xName() const;
    QString yName() const;
    void setXName(QString value);
    void setYName(QString value);

    bool isLatLong();
    bool isGeoCent();
    double fromMeter();
    double toMeter();

    Projection();

signals:
    void definitionChanged();
    void titleChanged();
    void coordinateChanged();
    void transformed();
    void xNameChanged();
    void yNameChanged();

public slots:

protected:
    void transform();

private:
    QString _title;
    QGeoCoordinate _coordinate;

    QString _source;
    QString _destination;
    PJ *_pj_source;
    PJ *_pj_destination;

    double _x;
    double _y;
    double _z;

    QString _xname;
    QString _yname;
};

#endif // PROJ4PROJECTION_H

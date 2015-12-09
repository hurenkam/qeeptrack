#ifndef PROJ4PROJECTION_H
#define PROJ4PROJECTION_H

#include <QObject>
#include <QString>
#include <QGeoCoordinate>
#include <projects.h>

class P4Coordinate
{
    Q_GADGET
    Q_PROPERTY(double x        READ x)
    Q_PROPERTY(double y        READ y)
    Q_PROPERTY(double z        READ z)
    Q_PROPERTY(bool   isValid  READ isValid)

public:
    P4Coordinate()
        : _x(0), _y(0), _z(0), _isValid(false) {}

    P4Coordinate(double x, double y, double z)
        : _x(x), _y(y), _z(z), _isValid(true) {}

    double x()       const { return _x; }
    double y()       const { return _y; }
    double z()       const { return _z; }
    bool   isValid() const { return _isValid; }

private:
    double _x;
    double _y;
    double _z;
    bool _isValid;
};

class P4Projection
{
    Q_GADGET
    Q_PROPERTY(QString definition  READ definition)
    Q_PROPERTY(bool    isValid     READ isValid)

public:
    P4Projection(): _pj(0) {}
    P4Projection(QString s);

    QString definition() const { return _definition; }
    bool    isValid() const    { return (_pj != 0); }

protected:
    void setDefinition(QString s);
    PJ* pj() const { return _pj; }

private:
    QString _definition;
    PJ* _pj;

    friend class P4Singleton;
};

class P4Singleton: public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE P4Coordinate coordinate(double x, double y, double z);
    Q_INVOKABLE P4Projection projection(QString s);
    Q_INVOKABLE P4Coordinate transform(P4Coordinate p4c, P4Projection from, P4Projection to);
};

#endif // PROJ4PROJECTION_H

#include "projection.h"

Projection::Projection()
    : QObject()
{
    _source = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs";
    _destination = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs";
    _title = "WGS84";
    _x = 0;
    _y = 0;
    _z = 0;

    _pj_source =       pj_init_plus(_source.toLatin1());
    _pj_destination =  pj_init_plus(_destination.toLatin1());
}

QString Projection::definition() const
{
    return _destination;
}

void Projection::setDefinition(QString value)
{
    _destination = value;
    _pj_destination = pj_init_plus(_destination.toLatin1());

    definitionChanged();
    transform();
}

QString Projection::title() const
{
    return _title;
}

void Projection::setTitle(QString value)
{
    _title = value;
    titleChanged();
}

QString Projection::xName() const
{
    return _xname;
}

void Projection::setXName(QString value)
{
    _xname = value;
    xNameChanged();
}

QString Projection::yName() const
{
    return _yname;
}

void Projection::setYName(QString value)
{
    _yname = value;
    yNameChanged();
}

QGeoCoordinate Projection::coordinate() const
{
    return _coordinate;
}

void Projection::setCoordinate(QGeoCoordinate value)
{
    _coordinate = value;
    transform();
}

void Projection::transform()
{
    if (!_coordinate.isValid())
        return;

    _x = _coordinate.longitude();
    _y = _coordinate.latitude();
    _z = 0;

    if (_source == _destination)
    {
        transformed();
    }
    else
    {
        if ((_pj_source == 0) || (_pj_destination == 0))
            return;

        double x = _x;
        double y = _y;
        double z = _z;

        if (_pj_source->is_latlong)
        {
            x *= DEG_TO_RAD;
            y *= DEG_TO_RAD;
        }

        int result = pj_transform(_pj_source,_pj_destination,1,1,&x,&y,&z);

        if (result != 0)
            return;

        if (_pj_destination->is_latlong)
        {
            //setXName("Lon:");
            //setYName("Lat:");
            x *= RAD_TO_DEG;
            y *= RAD_TO_DEG;
        }
/*
        else
        {
            setXName("X:");
            setYName("Y:");
        }
*/
        _x = x;
        _y = y;
        _z = z;
        transformed();
    }
}

double Projection::x() const
{
    return _x;
}

double Projection::y() const
{
    return _y;
}

double Projection::z() const
{
    return _z;
}

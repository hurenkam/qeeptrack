#include "projection.h"

P4Projection::P4Projection(QString s)
    : _definition(s)
{
    _pj = pj_init_plus(_definition.toLatin1());
    _isValid = (_pj != 0);
}

void P4Projection::setDefinition(QString s)
{
    _definition = s;
    if (_pj != 0)
        delete _pj;
    _pj = pj_init_plus(_definition.toLatin1());
    _isValid = (_pj != 0);
}

P4Coordinate P4Singleton::coordinate(double x, double y, double z)
{
    return P4Coordinate(x,y,z);
}

P4Projection P4Singleton::projection(QString s)
{
    return P4Projection(s);
}

P4Coordinate P4Singleton::transform(P4Coordinate p4c, P4Projection from, P4Projection to)
{
    if (!p4c.isValid() || !from.isValid() || !to.isValid())
        return P4Coordinate();

    double x = p4c.x();
    double y = p4c.y();
    double z = p4c.z();

    if (from.pj()->is_latlong)
    {
        x *= DEG_TO_RAD;
        y *= DEG_TO_RAD;
    }

    int result = pj_transform(from.pj(),to.pj(),1,1,&x,&y,&z);

    if (result != 0)
        return P4Coordinate();

    if (to.pj()->is_latlong)
    {
        x *= RAD_TO_DEG;
        y *= RAD_TO_DEG;
    }

    return P4Coordinate(x,y,z);
}

/*
void P4Coordinate::setXYZ(double x, double y, double z)
{
    _x = x;
    _y = y;
    _z = z;
    _valid = true;
    emit coordinateChanged();
    emit validChanged();
}

P4Coordinate* Projection::Proj4coordinate() const
{
    return new P4Coordinate();
}



void P4Transformer::setSource(QString value)
{
    _source = value;
    _spj = pj_init_plus(_source.toLatin1());
    sourceChanged();
}

void P4Transformer::setDestination(QString value)
{
    _destination = value;
    _dpj = pj_init_plus(_destination.toLatin1());
    destinationChanged();
}

P4Coordinate* P4Transformer::forward(P4Coordinate* value) const
{
    if ((_spj == 0) || (_dpj == 0) || (value == 0) || (!value->valid()))
        return 0;

    double x = value->x();
    double y = value->y();
    double z = value->z();

    if (_spj->is_latlong)
    {
        x *= DEG_TO_RAD;
        y *= DEG_TO_RAD;
    }

    int result = pj_transform(_spj,_dpj,1,1,&x,&y,&z);

    if (result != 0)
        return 0;

    if (_dpj->is_latlong)
    {
        x *= RAD_TO_DEG;
        y *= RAD_TO_DEG;
    }

    return new P4Coordinate(x,y,z);
}

P4Coordinate* P4Transformer::reverse(P4Coordinate* value) const
{
    if ((_spj == 0) || (_dpj == 0) || (value == 0) || (!value->valid()))
        return 0;

    double x = value->x();
    double y = value->y();
    double z = value->z();

    if (_dpj->is_latlong)
    {
        x *= DEG_TO_RAD;
        y *= DEG_TO_RAD;
    }

    int result = pj_transform(_dpj,_spj,1,1,&x,&y,&z);

    if (result != 0)
        return 0;

    if (_spj->is_latlong)
    {
        x *= RAD_TO_DEG;
        y *= RAD_TO_DEG;
    }

    return new P4Coordinate(x,y,z);
}
*/

/*
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

bool Projection::isLatLong()
{
    if (_pj_destination==0)
        return false;

    return _pj_destination->is_latlong;
}

bool Projection::isGeoCent()
{
    if (_pj_destination==0)
        return false;

    return _pj_destination->is_geocent;
}

double Projection::fromMeter()
{
    if (_pj_destination==0)
        return false;

    return _pj_destination->fr_meter;
}

double Projection::toMeter()
{
    if (_pj_destination==0)
        return false;

    return _pj_destination->to_meter;
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
*/

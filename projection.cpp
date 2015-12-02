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

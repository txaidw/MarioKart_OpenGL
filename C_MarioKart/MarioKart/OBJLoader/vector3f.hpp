//-----------------------------------------------------------------------------
//           Name: vector3f.h
//         Author: Kevin Harris
//  Last Modified: 02/01/05
//    Description: OpenGL compatible utility class for a 3D vector of floats
//                 NOTE: This class has been left unoptimized for readability.
//
//  Modified by Dennis Giovani Balreira -> dgbalreira at inf.ufrgs.br
//-----------------------------------------------------------------------------

#ifndef _VECTOR3F_H_
#define _VECTOR3F_H_

#include <cmath>

class vector3f
{
public:

    float x;
    float y;
    float z;

    vector3f(void)
    {
        x = 0.0f;
        y = 0.0f;
        z = 0.0f;
    }

    vector3f(float x_, float y_, float z_);
    void set(float x_, float y_, float z_);
    float length(void);
    void normalize(void);
    vector3f cross(const vector3f &v1);
    float dot(const vector3f &v1);

    // Static utility methods
    static float distance(const vector3f &v1, const vector3f &v2);
    static float dotProduct(const vector3f &v1,  const vector3f &v2 );
    static vector3f crossProduct(const vector3f &v1, const vector3f &v2);


    // Operators...
    vector3f operator + (const vector3f &other);
    vector3f operator - (const vector3f &other);
    vector3f operator * (const vector3f &other);
    vector3f operator / (const vector3f &other);

    vector3f operator * (const float scalar);
    friend vector3f operator * (const float scalar, const vector3f &other);

    vector3f& operator = (const vector3f &other);
    vector3f& operator += (const vector3f &other);
    vector3f& operator -= (const vector3f &other);

    vector3f operator + (void) const;
    vector3f operator - (void) const;
};

 vector3f::vector3f( float x_, float y_, float z_ )
{
    x = x_;
    y = y_;
    z = z_;
}

void vector3f::set( float x_, float y_, float z_ )
{
    x = x_;
    y = y_;
    z = z_;
}

float vector3f::length( void )
{
    return( (float)sqrt( x * x + y * y + z * z ) );
}

void vector3f::normalize( void )
{
    float fLength = length();

    x = x / fLength;
    y = y / fLength;
    z = z / fLength;
}

vector3f vector3f::cross(const vector3f &v1)
{
    vector3f vCross;

    vCross.x =  y * v1.z - z * v1.y;
    vCross.y = -x * v1.z + z * v1.x;
    vCross.z =  x * v1.y - y * v1.x;
    return vCross;
}

float vector3f::dot(const vector3f &v1)
{
    return( x * v1.x + y * v1.y + z * v1.z  );
}

// Static utility methods...

static float distance( const vector3f &v1,  const vector3f &v2  )
{
    float dx = v1.x - v2.x;
    float dy = v1.y - v2.y;
    float dz = v1.z - v2.z;

    return (float)sqrt( dx * dx + dy * dy + dz * dz );
}

static float dotProduct( const vector3f &v1,  const vector3f &v2 )
{
    return( v1.x * v2.x + v1.y * v2.y + v1.z * v2.z  );
}



static vector3f crossProduct( const vector3f &v1,  const vector3f &v2 )
{
    vector3f vCrossProduct;

    vCrossProduct.x =  v1.y * v2.z - v1.z * v2.y;
    vCrossProduct.y = -v1.x * v2.z + v1.z * v2.x;
    vCrossProduct.z =  v1.x * v2.y - v1.y * v2.x;

    return vCrossProduct;
}

// Operators...

vector3f vector3f::operator + ( const vector3f &other )
{
    vector3f vResult(0.0f, 0.0f, 0.0f);

    vResult.x = x + other.x;
    vResult.y = y + other.y;
    vResult.z = z + other.z;

    return vResult;
}

vector3f vector3f::operator + ( void ) const
{
    return *this;
}

vector3f vector3f::operator - ( const vector3f &other )
{
    vector3f vResult(0.0f, 0.0f, 0.0f);

    vResult.x = x - other.x;
    vResult.y = y - other.y;
    vResult.z = z - other.z;

    return vResult;
}

vector3f vector3f::operator - ( void ) const
{
    vector3f vResult(-x, -y, -z);

    return vResult;
}

vector3f vector3f::operator * ( const vector3f &other )
{
    vector3f vResult(0.0f, 0.0f, 0.0f);

    vResult.x = x * other.x;
    vResult.y = y * other.y;
    vResult.z = z * other.z;

    return vResult;
}

vector3f vector3f::operator * ( const float scalar )
{
    vector3f vResult(0.0f, 0.0f, 0.0f);

    vResult.x = x * scalar;
    vResult.y = y * scalar;
    vResult.z = z * scalar;

    return vResult;
}

vector3f operator * ( const float scalar, const vector3f &other )
{
    vector3f vResult(0.0f, 0.0f, 0.0f);

    vResult.x = other.x * scalar;
    vResult.y = other.y * scalar;
    vResult.z = other.z * scalar;

    return vResult;
}

vector3f vector3f::operator / ( const vector3f &other )
{
    vector3f vResult(0.0f, 0.0f, 0.0f);

    vResult.x = x / other.x;
    vResult.y = y / other.y;
    vResult.z = z / other.z;

    return vResult;
}

vector3f& vector3f::operator = ( const vector3f &other )
{
    x = other.x;
    y = other.y;
    z = other.z;

    return *this;
}

vector3f& vector3f::operator += ( const vector3f &other )
{
    x += other.x;
    y += other.y;
    z += other.z;

    return *this;
}

vector3f& vector3f::operator -= ( const vector3f &other )
{
    x -= other.x;
    y -= other.y;
    z -= other.z;

    return *this;
}

#endif // _VECTOR3F_H_

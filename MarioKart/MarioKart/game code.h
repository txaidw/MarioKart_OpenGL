//=========================================================
//
// Simple Physics Demo
//
//=========================================================
#ifndef OLI_GAME_CODE_H
#define OLI_GAME_CODE_H

#include <math.h>
#include <GLUT/glut.h>

//--------------------------------------------------------------------------
// random float
//--------------------------------------------------------------------------
extern float frand(float range);
extern float sgn(float x);
extern void SetMaterial(int ColorIndex, float transparency);

//===========================================================================
// VECTORS
//===========================================================================
class Vector
{
public:
	float x,y,z;

public:
	inline Vector(void)
	{}

	inline Vector(float Ix,float Iy,float Iz): x(Ix), y(Iy), z(Iz) {}

	inline Vector &operator /=(const float Scalar) { *this *= (1.0f / Scalar);	return *this; }

	inline Vector &operator *=(const float Scalar) { x *= Scalar; y *= Scalar; z *= Scalar;	return *this; }

	inline Vector &operator +=(const Vector &Other) { x += Other.x;	y += Other.y;	z += Other.z; return *this; }

	inline Vector &operator -=(const Vector &Other) { x -= Other.x;	y -= Other.y;	z -= Other.z; return *this;	}

	inline Vector& operator ^=(const Vector &V) // Cross product
	{
		float Tempx	= (y * V.z) - (z * V.y);
		float Tempy	= (z * V.x) - (x * V.z);
		      z		= (x * V.y) - (y * V.x);
		      x     = Tempx;
		      y     = Tempy;

		return *this;
	}

	inline Vector operator ^ (const Vector& V) const {	Vector Temp(*this); return Temp ^= V; }

	inline Vector operator * (float  s)		   const {	Vector Temp(*this); return Temp *= s; };

	inline Vector operator / (float  s)		   const {	Vector Temp(*this); return Temp /= s; }

	inline Vector operator + (const Vector &V) const {	Vector Temp(*this); return Temp += V; }

	inline Vector operator - (const Vector &V) const {	Vector Temp(*this); return Temp -= V; }

	friend Vector operator * (float k, const Vector& V) { return V * k; } // dot product

	inline float operator * (const Vector &V) const { return (x * V.x) + (y * V.y) + (z * V.z); }

	inline Vector operator -(void) const { return Vector(-x, -y, -z); }

	inline float GetLength(void) const { return (float) sqrt((*this) * (*this)); }

	float Normalise()
	{
		float Length = GetLength();

		if (Length == 0.0f)
			return 0.0f;

		(*this) *= (1.0f / Length);

		return Length;
	}

	static Vector Random(const Vector& Radius=Vector(1.0f, 1.0f, 1.0f))
	{
		return Vector(frand(Radius.x), frand(Radius.y), frand(Radius.z));
	}

	static Vector Random(float radius)
	{
		return Vector(frand(radius), frand(radius), frand(radius));
	}

	//-------------------------------------------------------------------------
	// Compute normal of a triangle. return normal length
	//-------------------------------------------------------------------------
	float ComputeNormal(const Vector& V0, const Vector& V1, const Vector& V2)
	{
		Vector E = V1; E -= V0;
		Vector F = V2; F -= V1;

		(*this)  = E ^ F;

		return (*this).Normalise();
	}

	void Render(void) const
	{
		glPointSize(3.0f);
		glBegin(GL_POINTS);
		glVertex3fv(&x);
		glEnd();
	}
	static void Render(const Vector& V0, const Vector& V1)
	{
		V0.Render();
		V1.Render();
		glBegin(GL_LINES);
		glVertex3fv(&V0.x);
		glVertex3fv(&V1.x);
		glEnd();
	}
};


//------------------------------------------------------------------
// Game interface
//------------------------------------------------------------------
extern void GameInit();
extern void GameUpdate();
extern void GameRender();
extern void GameAddImpulseToObject(int iObjectID, const Vector& xImpulse);
extern Vector GameGetObjectPos(int iObjectID);

#endif //OLI_GAME_CODE_H

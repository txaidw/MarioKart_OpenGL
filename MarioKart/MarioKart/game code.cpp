//=========================================================
//
// Simple Physics Demo
//
//=========================================================
#include <stdlib.h>
#include <stdio.h>

#include "Game Code.h"

//---------------------------------------------------------------------
// Base collision object class
//---------------------------------------------------------------------
struct CObject
{
public:
	//---------------------------------------------------------------------
	// Constructors
	//---------------------------------------------------------------------
	CObject()
	{}
	
	CObject(const Vector& xPos, const Vector& xVel, float fMass)
	: m_xPos(xPos)
	, m_xVel(xVel)
	, m_fMass(fMass)
	{
	}

	//---------------------------------------------------------------------
	// Modifiers / Selectors
	//---------------------------------------------------------------------
 	bool IsStatic(void) const { return (m_fMass < 0.0000001f); }

	const Vector& GetPosition() const { return m_xPos; }
	const Vector& GetVelocity() const { return m_xVel; }
	float         GetMass    () const { return m_fMass; }

	void SetPosition(const Vector& xPos)  { m_xPos = xPos;   }
 	void SetVelocity(const Vector& xVel)  { m_xVel = xVel;   }
  	void SetMass    (float         fMass) { m_fMass = fMass; }
   
	//---------------------------------------------------------------------
	// Member functions
	//---------------------------------------------------------------------
   	void Update(float dt)
	{
		if (IsStatic())	// only massive objects can be moved
			return;
			
		m_xPos += m_xVel * dt;
	}
	
	//---------------------------------------------------------------------
	// Virtual Interface
	//---------------------------------------------------------------------
	virtual void Render(void) const = 0;
	virtual bool Intersect(const       CObject& xObject, Vector& xP0, Vector &xP1) const = 0;
	virtual bool Intersect(const class CSphere& xSphere, Vector& xP0, Vector &xP1) const = 0;
	virtual bool Intersect(const class CAABBox& xBox,    Vector& xP0, Vector &xP1) const = 0;

	//-------------------------------------------------
	// process the collision response on two objects
	//-------------------------------------------------
    bool ProcessCollision(CObject& xObj, const Vector& xThisPoint, const Vector& xObjPoint)
    {
		Vector N = xObjPoint - xThisPoint;			// normal of plane of collision

		//-------------------------------------------------
		// calcualte the amount of collison response for both objects
		//-------------------------------------------------
		float fRatio1, fRatio2;
		if (!CalculateMassRatio(xObj, fRatio1, fRatio2, true))
			return false;
		
		m_xPos      += N * fRatio1;					// move the Objects away from each other
  		xObj.m_xPos -= N * fRatio2;

  		Vector xVel = m_xVel - xObj.m_xVel;		// Calcualte the relative velocity

		float nv = N * xVel;           				// Calcualte the impact velocity

		if (nv > 0.0f)								// spheres moving away from each other, so don't reflect
			return false;

       	float n2 = N * N;							// the normal of collision length squared

		if (n2 < 0.00001f)							// to small, can't be of any use
			return false;

		CalculateMassRatio(xObj, fRatio1, fRatio2, false);
		
		float fElasticity = 0.8f;	// coefficient of elqsticity
		float fFriction   = 0.1f;	// coefficient of friciton
		
		//----------------------------------------------
		// Collision response. Calcualte the two velocity components
		//----------------------------------------------
		Vector Vn = N * (nv / n2);		// relative velocity alon the normal of collision
		Vector Vt = xVel - Vn;			// tangencial velocity (along the collision plane)

		//----------------------------------------------
		// apply response
		// V = -Vn . (1.0f + CoR) + Vt . CoF
		//----------------------------------------------
		m_xVel      -= ((1.0f + fElasticity) * fRatio1) * Vn + Vt * fFriction;	// reflect the first sphere
		xObj.m_xVel += ((1.0f + fElasticity) * fRatio2) * Vn + Vt * fFriction;	// reflect the second sphere

		return true;
    }
private:
	//-------------------------------------------------
	// calcualte the amount of collison response for both objects
	// based on the ratio of mass
	// if one of the object is static (mass = 0.0f)
	// then the amount of response will be maximum on the mobile object
	// to avoid squqshing objects against static walls,
	// you can set the amount of impulse equally apart when separating objects
	//-------------------------------------------------
	bool CalculateMassRatio(CObject& xObj, float &fRatio1, float& fRatio2, bool bNormalise=false)
	{
		float m = (GetMass() + xObj.GetMass());

		if (m < 0.000001f)
			return false;
			
		else if (xObj.GetMass() < 0.0000001f)
		{
			fRatio1 = 1.0f;
			fRatio2 = 0.0f;
		}
		else if (GetMass() < 0.0000001f)
		{
			fRatio1 = 0.0f;
			fRatio2 = 1.0f;
		}
		else
		{
			if (bNormalise)
			{
				fRatio1 = 0.5f;
				fRatio2 = 1.0f - fRatio1;
			}
			else
			{
				fRatio1 = xObj.GetMass() / m;
				fRatio2 = 1.0f - fRatio1;
			}
		}

		return true;
	}

protected:
	Vector m_xPos;
	Vector m_xVel;
	float  m_fMass;

};


//---------------------------------------------------------------------------
// Object list management
//
// Maintain a list of objects, for collision and rendering
//---------------------------------------------------------------------------
class CObjectList
{
public:
	//---------------------------------------------------------------------------
	// cosntructors
 	//---------------------------------------------------------------------------
	CObjectList()
	: m_iNumObjects(0)
	{}
	
	//---------------------------------------------------------------------------
	// update all the objects
	//---------------------------------------------------------------------------
	void Update(float dt)
	{
		//---------------------------------------------------------------------------
		// update all the objects positions
		//---------------------------------------------------------------------------
		for(int i = 0; i < m_iNumObjects; i ++)
		{
			m_pxObjects[i]->Update(dt);
		}

		//---------------------------------------------------------------------------
		// test all objects against each other and process all collisions
		//---------------------------------------------------------------------------
		for(int i = 0; i < m_iNumObjects; i ++)
		{
			for (int j = i+1; j < m_iNumObjects; j ++)
			{
				//---------------------------------------------------------------------------
    			// test collision between two objects
    			//---------------------------------------------------------------------------
				if (m_pxObjects[i]->IsStatic() && m_pxObjects[j]->IsStatic())
					continue;

				//---------------------------------------------------------------------------
    			// process the collision
    			//---------------------------------------------------------------------------
     			Vector xP0;
     			Vector xP1;
     			if (m_pxObjects[i]->Intersect(*m_pxObjects[j], xP0, xP1))
     			{
     				m_pxObjects[i]->ProcessCollision(*m_pxObjects[j], xP0, xP1);
     			}
			}
		}
	}

	//---------------------------------------------------------------------------
	// render all the objects
	//---------------------------------------------------------------------------
	void Render() const
	{
		for(int i = 0; i < m_iNumObjects; i ++)
		{
			m_pxObjects[i]->Render();
		}
	}
	//---------------------------------------------------------------------------
	// Add object reference to list
	//---------------------------------------------------------------------------
	void RegisterObject(CObject* pxNewObject)
	{
		for(int i = 0; i < m_iNumObjects; i ++)
		{
			if (m_pxObjects[i] == pxNewObject)
				return;
		}

		if (m_iNumObjects >= eMaxObjects)
			return;

  		m_pxObjects[m_iNumObjects] = pxNewObject;
  		m_iNumObjects++;
	}

	//---------------------------------------------------------------------------
	// remove object reference to list
	//---------------------------------------------------------------------------
	void UnregisterObject(CObject* pxOldObject)
	{
		int i;
		for(i = 0; i < m_iNumObjects; i ++)
		{
			if (m_pxObjects[i] == pxOldObject)
				break;
		}
		if (i == m_iNumObjects)
			return;

		m_iNumObjects--;
		m_pxObjects[i] = m_pxObjects[m_iNumObjects];
	}
private:
	enum { eMaxObjects = 128 };
	CObject* m_pxObjects[eMaxObjects];
	int m_iNumObjects;
};

//---------------------------------------------------------------------------
// Collision sphere structure
//---------------------------------------------------------------------------
struct CSphere: public CObject
{
public:
	//---------------------------------------------------------------------------
	// Constrcutors
	//---------------------------------------------------------------------------
	CSphere()
	{}

	CSphere(const Vector& xPos, float fRad, float fMass)
	: CObject(xPos, Vector(0, 0, 0), fMass)
	, m_fRad(fRad)
	{}

	//---------------------------------------------------------------------
	// Modifiers / Selectors
	//---------------------------------------------------------------------
	float GetRadius() const { return m_fRad; }

	//---------------------------------------------------------------------
	// Virtual Interface
	//---------------------------------------------------------------------
	virtual bool Intersect(const CObject& xObject, Vector& xP0, Vector &xP1) const
 	{
  		return xObject.Intersect(*this, xP1, xP0);
  	}
	virtual bool Intersect(const class CAABBox& xBox,  Vector& xP0, Vector &xP1) const;
	virtual bool Intersect(const CSphere &xSphere, Vector& xP0, Vector& xP1) const;
	virtual void Render(void) const
	{
		if (IsStatic())
		 	SetMaterial(4, 1.0f);
    	else
    	 	SetMaterial(5, 1.0f);
    	 	
		glPushMatrix();
		glTranslatef(m_xPos.x, m_xPos.y, m_xPos.z);
		glutSolidSphere(m_fRad, 8, 8);
		glPopMatrix();
	}

private:
	float  m_fRad;
};


//---------------------------------------------------------------------------
// Axis-aligned box collision object
//---------------------------------------------------------------------------
struct CAABBox: public CObject
{
public:
	//---------------------------------------------------------------------------
	// Constrcutors
	//---------------------------------------------------------------------------
	CAABBox()
	{}

	CAABBox(const Vector& xPos, const Vector& xExt, float fMass)
	: CObject(xPos, Vector(0, 0, 0), fMass)
	, m_xExt(xExt)
	{}

	//---------------------------------------------------------------------
	// Modifiers / Selectors
	//---------------------------------------------------------------------
	const Vector& GetExt() const { return m_xExt; }

	//---------------------------------------------------------------------
	// Virtual Interface
	//---------------------------------------------------------------------
	virtual bool Intersect(const CObject& xObject, Vector& xP0, Vector &xP1) const
 	{
 		return xObject.Intersect(*this, xP1, xP0);
    }
	virtual bool Intersect(const class CSphere& xSphere, Vector& pBox, Vector &pSphere) const;
	virtual bool Intersect(const class CAABBox& xBox, Vector& xP0, Vector &xP1) const;
	virtual void Render(void) const
	{
		if (IsStatic())
		 	SetMaterial(2, 1.0f);
    	else
    	 	SetMaterial(3, 1.0f);

		if (IsStatic())
		 	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    	else
		 	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

      	glPushMatrix();
		glTranslatef(m_xPos.x, m_xPos.y, m_xPos.z);
		glScalef(m_xExt.x, m_xExt.y, m_xExt.z);
		glutSolidCube(2.0f);
		glPopMatrix();
	}

private:
	Vector m_xExt;
};

//---------------------------------------------------------------------------
// MAIN INTERSECTION ROUTINES
// --------------------------
// return if two objects intersect, and where on the surface of the objects
// Note : for AABBox vs. AABBox, the test only returns teh separation vector
// -----  This is sufficient, because that's all that is needed in the collison
// -----  response. The other objects return the actual points on the surface
// -----  for demonstration pruposes.
//---------------------------------------------------------------------------
bool CSphere::Intersect(const class CAABBox& xBox,  Vector& xP0, Vector &xP1) const
{
	return xBox.Intersect(*this, xP1, xP0);
}

//---------------------------------------------------------------------------
// Sphere vs. Sphere collision
//---------------------------------------------------------------------------
bool CSphere::Intersect(const CSphere &xSphere, Vector& pP0, Vector& pP1) const
{
	Vector pDist    = xSphere.GetPosition() - GetPosition(); 			// relative position of sphere centre to the box centre
	float dist2 	= pDist * pDist;									// distance of the point on the box to sphere centre, squared
	float r 		= GetRadius() + xSphere.GetRadius();
	float r2    	= r * r;
	if (dist2 > r2) return false;									// point outside sphere, no intersection

	//------------------------------------------------------
	// calcualte point on sphere surface closest to point on box.
	//------------------------------------------------------
	pDist /= sqrt(dist2); // normalise
	pP0    =         GetPosition() + pDist *         GetRadius();
	pP1    = xSphere.GetPosition() - pDist * xSphere.GetRadius();
	return true;
}

//---------------------------------------------------------------------------
// tool to calcualte the amount of overlap between two spans along an axis
//---------------------------------------------------------------------------
bool AxisIntersect(float min0, float max0, float min1, float max1, float& d)
{
	float d0 = max1 - min0;
 	float d1 = max0 - min1;

	if (d0 < 0.0f || d1 < 0.0f)
 		return false;

	if (d0 < d1)
		d = d0;
    else
    	d = -d1;
					
	return true;
}

//---------------------------------------------------------------------------
// AABBox vs. AABBox intersection test.
// (as stated above, it only returns the separation vector, not the collison points).
//---------------------------------------------------------------------------
bool CAABBox::Intersect(const class CAABBox& xBox, Vector& xP0, Vector &xP1) const
{
	//---------------------------------------------------------------------------
	// calculate the box boundaries, as it is easier that way for the test
 	//---------------------------------------------------------------------------
	Vector xMin0 =      GetPosition() -      GetExt();
	Vector xMax0 =      GetPosition() +      GetExt();
	Vector xMin1 = xBox.GetPosition() - xBox.GetExt();
	Vector xMax1 = xBox.GetPosition() + xBox.GetExt();
	
	//---------------------------------------------------------------------------
	// test intersection along x axis
 	//---------------------------------------------------------------------------
 	Vector N(0, 0, 0);
 	if (!AxisIntersect(xMin0.x, xMax0.x, xMin1.x, xMax1.x, N.x))
 		return false;

	//---------------------------------------------------------------------------
	// test intersection along y axis
 	//---------------------------------------------------------------------------
 	if (!AxisIntersect(xMin0.y, xMax0.y, xMin1.y, xMax1.y, N.y))
 		return false;

	//---------------------------------------------------------------------------
	// test intersection along z axis
 	//---------------------------------------------------------------------------
 	if (!AxisIntersect(xMin0.z, xMax0.z, xMin1.z, xMax1.z, N.z))
 		return false;
 		
	//---------------------------------------------------------------------------
	// select the axis with the minimum of separation as the collision axis
 	//---------------------------------------------------------------------------
  	float mindist = fabs(N.x);
  	
  	if (fabs(N.y) < mindist)
  	{
     	mindist = fabs(N.y);
     	N.x = 0.0f;
  	}
  	else
  	{
 	 	N.y = 0.0f;
  	}
  	if (fabs(N.z) < mindist)
  	{
     	N.x = N.y = 0.0f;
  	}
  	else
  	{
 	 	N.z = 0.0f;
  	}
  	
  	xP0 = Vector(0, 0, 0);
  	xP1 = N;
  	
  	return true;
}

//---------------------------------------------------------------------------
// AABBox vs. Sphere
//---------------------------------------------------------------------------
bool CAABBox::Intersect(const class CSphere& xSphere, Vector& pBox, Vector &pSphere) const
{
	Vector pDiff = xSphere.GetPosition() - GetPosition();  // relative position of sphere centre to the box centre
	Vector pExt = GetExt();									// size of the box along X, Y and Z direction.

	//------------------------------------------------------
 	// see if sphere coords are within the box coords
	//------------------------------------------------------
	float dx = pExt.x - fabs(pDiff.x);	// distance of sphere centre to one of the X-Face of the box
	float dy = pExt.y - fabs(pDiff.y);	// distance of sphere centre to one of the Y-Face of the box
	float dz = pExt.z - fabs(pDiff.z);	// distance of sphere centre to one of the Z-Face of the box

	bool outx  =  (dx < 0.0f);		// sphere centre between the two X-Faces of the box
	bool outy  =  (dy < 0.0f);		// sphere centre between the two Y-Faces of the box
	bool outz  =  (dz < 0.0f);		// sphere centre between the two Z-Faces of the box
	bool in    = !(outx|outy|outz);	// sphere centre inside all the faces of the box

	//------------------------------------------------------
	// sphere centre in the box. deep intersection
	//------------------------------------------------------
	if (in)
	{
		//------------------------------------------------------
		// find closest plane on box to the sphere centre.
		//------------------------------------------------------
		float mindist;

		if (1)																	// one of the X-Face closest to the spehre centre?
		{																		//
			mindist = dx;														//
			pBox    = Vector(dx * sgn(pDiff.x), 0.0f, 0.0f);					// which X-Face of the box closest to sphere
			pSphere = Vector(-xSphere.GetRadius() * sgn(pDiff.x), 0.0f, 0.0f);	// point on the sphere furthest from the face
		}

		if (dy < mindist)														// one of the Y-Face closest to the spehre centre?
		{																		//
			mindist = dy;														//
			pBox    = Vector(0.0f, dy * sgn(pDiff.y), 0.0f);					// which Y-Face of the box closest to sphere
			pSphere = Vector(0.0f, -xSphere.GetRadius() * sgn(pDiff.y), 0.0f);	// point on the sphere furthest from the face
		}
		if (dz < mindist)														// one of the Z-Face closest to the spehre centre?
		{																		//
			mindist = dz;														//
			pBox    = Vector(0.0f, 0.0f, dz * sgn(pDiff.z));					// which Z-Face of the box closest to sphere
			pSphere = Vector(0.0f, 0.0f, -xSphere.GetRadius() * sgn(pDiff.z));	// point on the sphere furthest from the face
		}
		pBox    += xSphere.GetPosition();
		pSphere += xSphere.GetPosition();

		return true;
	}
	//------------------------------------------------------
	// sphere centre not in the box. This is the general case
	//------------------------------------------------------
	else
	{
		//------------------------------------------------------
		// find the closest plane on the box to the sphere
		// (could be a corner, an edge or a face of the box).
		//------------------------------------------------------
		pBox = pDiff;
		if (outx) pBox.x = sgn(pDiff.x) * pExt.x;
		if (outy) pBox.y = sgn(pDiff.y) * pExt.y;
		if (outz) pBox.z = sgn(pDiff.z) * pExt.z;
		pBox += GetPosition();

		//------------------------------------------------------
		// see if the point on  the box surface is in the sphere,
		// by checking the distance of the point from the sphere
		// centre against the sphere radius.
		//------------------------------------------------------
		Vector pDist 	= pBox - xSphere.GetPosition();						// relative position of point in box to the sphere centre
		float dist2 	= pDist * pDist;								// distance of the point on the box to sphere centre, squared
		float r2    	= xSphere.GetRadius() * xSphere.GetRadius();	// radius of sphere, squared
		if (dist2 > r2) return false;									// point outside sphere, no intersection

		//------------------------------------------------------
		// calcualte point on sphere surface closest to point on box.
		//------------------------------------------------------
		pDist /= sqrt(dist2); // normalise
		pDist *= xSphere.GetRadius();

		pSphere  = pDist;
		pSphere += xSphere.GetPosition();

		return true;
	}
}

//-----------------------------------------------------------------------------
// Game Interface
//-----------------------------------------------------------------------------
enum { iNumSpheres = 10, iNumBoxes = 20, iNumWalls = 6 };
CAABBox xBoxes  [iNumBoxes];		// all boxes in the world
CSphere xSpheres[iNumSpheres];		// all spheres in the world
CObjectList xObjectList;			// all objects in the world wrapped up in a list


//-----------------------------------------------------------------------------
// add impulse to an object
//-----------------------------------------------------------------------------
void GameAddImpulseToObject(int iObjectID, const Vector& xImpulse)
{
	if (iObjectID < 0 || iObjectID >= iNumSpheres)
		return;
		
	xSpheres[iObjectID].SetVelocity(xImpulse);
}

//-----------------------------------------------------------------------------
// get an object position
//-----------------------------------------------------------------------------
Vector GameGetObjectPos(int iObjectID)
{
	if (iObjectID < 0 || iObjectID >= iNumSpheres)
		return Vector(0, 0, 0);

	return xSpheres[iObjectID].GetPosition();
}

//-----------------------------------------------------------------------------
// Init the game state
//-----------------------------------------------------------------------------
void GameInit()
{
	xBoxes[0]	= CAABBox (Vector(-200, 0, 0), Vector(100, 100, 100), 0.0f);
	xBoxes[1]	= CAABBox (Vector( 200, 0, 0), Vector(100, 100, 100), 0.0f);
	xBoxes[2]	= CAABBox (Vector( 0, 200, 0), Vector(100, 100, 100), 0.0f);
	xBoxes[3]	= CAABBox (Vector( 0,-200, 0), Vector(100, 100, 100), 0.0f);
	xBoxes[4]	= CAABBox (Vector( 0, 0,-200), Vector(100, 100, 100), 0.0f);
	xBoxes[5]	= CAABBox (Vector( 0, 0, 200), Vector(100, 100, 100), 0.0f);

	for (int i = iNumWalls; i < iNumBoxes; i ++)
	{
		xBoxes[i] = CAABBox(Vector::Random(200) - Vector(100, 100, 100), Vector::Random(20) + Vector(10, 10, 10), frand(1000.0f) + 1000.0f);
	}
	for (int i = 0; i < iNumSpheres; i ++)
		xSpheres[i] = CSphere(Vector::Random(200) - Vector(100, 100, 100), frand(10) + 2, frand(100.0f) + 10.0f);
		
	for(int i = 0; i < iNumBoxes; i ++)
		xObjectList.RegisterObject(&xBoxes[i]);
	for(int i = 0; i < iNumSpheres; i ++)
		xObjectList.RegisterObject(&xSpheres[i]);

}

//-----------------------------------------------------------------------------
// update the game state
//-----------------------------------------------------------------------------
void GameUpdate()
{
	xObjectList.Update(1.0f / 60.0f);
}

//-----------------------------------------------------------------------------
// render the game
//-----------------------------------------------------------------------------
void GameRender()
{
	xObjectList.Render();
}


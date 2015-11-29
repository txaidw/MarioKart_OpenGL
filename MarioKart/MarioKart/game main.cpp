//=========================================================
//
// Simple Physics Demo
//
//=========================================================
//#include <conio.h>
#include <math.h>
#include <time.h>		// 3x3 matrix class
#include <stdio.h>		// 3x3 matrix class
#include <stdlib.h>		// 3x3 matrix class
#include <memory.h>
#include <GLUT/glut.h>

#ifdef WIN32
#include <windows.h>
#include <winuser.h>
#endif

//------------------------------------------------------------------
// Game interface
//------------------------------------------------------------------
#include "Game Code.h"
#include "game main.h"
//--------------------------------------------------------------------------
// random float
//--------------------------------------------------------------------------
float frand(float range)
{
	return range * (rand() / (float)RAND_MAX);
}

float sgn(float x)
{
	return (x < 0.0f)? -1.0f : 1.0f;
}

//--------------------------------------------------------------------------
// openGL tool function
//--------------------------------------------------------------------------
void SetMaterial(int ColorIndex, float transparency)
{
	float t = transparency;
	float a = 0.5f, b = 1.0f;

	static GLfloat Color[16][4] = {	{ 0, 0, 0, t }, { a, 0, 0, t }, { 0, a, 0, t }, { 0, 0, a, t },
									{ a, a, 0, t }, { a, 0, a, t }, { 0, a, a, t }, { a, a, a, t },
		 							{ a, a, a, 1 }, { b, 0, 0, 1 }, { 0, b, 0, 1 }, { 0, 0, b, 1 },
									{ b, b, 0, 1 }, { b, 0, b, 1 }, { 0, b, b, 1 }, { b, b, b, 1 } };

	GLfloat Black[4] = { 0, 0, 0, 1 };
	GLfloat White[4] = { 1, 1, 1, 1 };

	int AmbientIndex = ColorIndex % 8;
	int DiffuseIndex = (AmbientIndex + 8) % 16;

	glMaterialfv(GL_FRONT, GL_AMBIENT  , Color[AmbientIndex]);
	glMaterialfv(GL_FRONT, GL_DIFFUSE  , Color[DiffuseIndex]);
	glMaterialfv(GL_FRONT, GL_EMISSION , Black);
	glMaterialfv(GL_FRONT, GL_SPECULAR , White);
	glMaterialf (GL_FRONT, GL_SHININESS, 20.0f);
}

//------------------------------------------------------------------
// cameras
//------------------------------------------------------------------
int screen_width  = 800;	// The width  of the screen in pixels
int screen_height = 600;	// The height of the screen in pixels
int screen_bpp    = 32;		// bits per pixels
int screen_hz     = 60;		// dispaly refresh 


Vector CamPos				[2]	= { Vector(0.0f, 0.0f, 0.0f), Vector(0.0f, 0.0f, 0.0f) };
Vector CamAngle				[2]	= { Vector(0.0f,  0.0f, 0.0f), Vector(0.5f, -0.5f, 0.0f) };
Vector CamMove				[2]	= { Vector(0.0f,  0.0f, 0.0f), Vector(0.0f,  0.0f, 0.0f) };
Vector CameraViewportPos	[2] = { Vector(0.0f,  0.5f, 0.0f), Vector(0.0f,  0.0f, 0.0f) };
Vector CameraViewportSize	[2] = { Vector(1.0f,  0.5f, 0.0f), Vector(1.0f,  0.5f, 0.0f) }; 
Vector CamLeft				[2]	= { Vector(1.0f,  0.0f, 0.0f), Vector(1.0f,  0.0f, 0.0f) };
Vector CamUp				[2]	= { Vector(0.0f,  1.0f, 0.0f), Vector(0.0f,  1.0f, 0.0f) };
Vector CamDir				[2]	= { Vector(0.0f,  0.0f, 1.0f), Vector(0.0f,  0.0f, 1.0f) };
//int	   CameraKeys			[2][6] = { { 'z', 's', 'q', 'd', 'a', 'w' }, { 'z', 's', 'q', 'd', 'a', 'w' } };
int	   CameraKeys			[2][6] = { { 'w', 's', 'a', 'd', 'q', 'z' }, { 'w', 's', 'a', 'd', 'q', 'z' } };
int	   CameraSphereID		[2] = { 0, 1 };
float  CameraFOV			[2] = { 90.0f, 90.0f };

enum { eNumCameras = 2 };

//------------------------------------------------------------------
// input buffer
//------------------------------------------------------------------
int mouse_x		=0;
int mouse_y		=0;
int mouse_button=0;
int old_mouse_x	=0;
int old_mouse_y	=0;
unsigned char key[256];

//--------------------------------------------------------------------------
// the rate of updates (recommended 5fps -> 60 fps for updates). 
//--------------------------------------------------------------------------
float dbg_updatefps		= 30.0f;
int	  dbg_update_frame	= 0;
int	  dbg_overlapped	= false;
float dbg_world_size	= 1000.0f; // size of world
int	  dbg_seed			=0;

const float dbg_Camera_movement_damping = 0.8f;
const float dbg_InputForce				= 40.0f;

void Init()
{	
	dbg_update_frame = 0;
	dbg_overlapped   = 0;

	dbg_seed = clock();

	srand(dbg_seed);

	GameInit();
 }

void UpdateCamera(int id)
{
	if (CameraSphereID[id] == -1)
	{
		CamMove[id].x *= dbg_Camera_movement_damping * 0.8f;
		CamMove[id].y *= dbg_Camera_movement_damping * 0.8f;
		CamMove[id].z *= dbg_Camera_movement_damping * 0.8f;
	}
	else
	{
		CamMove[id].x = 0.0f;
		CamMove[id].y = 0.0f;
		CamMove[id].z = 0.0f;
	}

	//---------------------------------------------
	// Handle controls
	//---------------------------------------------
	if (mouse_button == id + 1)
	{
		CamMove[id].z += ((key[CameraKeys[id][1]]) - (key[CameraKeys[id][0]])) * 1.0f;
		CamMove[id].x += ((key[CameraKeys[id][3]]) - (key[CameraKeys[id][2]])) * 1.0f;
		CamMove[id].y += ((key[CameraKeys[id][4]]) - (key[CameraKeys[id][5]])) * 1.0f;
	}

	//-----------------------------------------------------------------
	// handle mouse
	//-----------------------------------------------------------------
	if (mouse_button == id + 1)
	{
		CamAngle[id].x += ((mouse_y - old_mouse_y) / 200.0f);
		CamAngle[id].y += ((mouse_x - old_mouse_x) / 200.0f);
		CamAngle[id].x  = (CamAngle[id].x < -1.5f)? -1.5f : (CamAngle[id].x  > 1.5f)? 1.5f : CamAngle[id].x;
	}

	//-----------------------------------------------------------------
	// setup camera position
	//-----------------------------------------------------------------
	float cos_yaw = (float) cos(CamAngle[id].y);
	float sin_yaw = (float)-sin(CamAngle[id].y);
	
	float cos_pitch = (float)cos(CamAngle[id].x);
	float sin_pitch = (float)sin(CamAngle[id].x);

	CamLeft[id] = Vector( cos_yaw,             0.0f,      -sin_yaw);
	CamDir [id] = Vector( sin_yaw * cos_pitch, sin_pitch,  cos_yaw * cos_pitch);
	CamUp  [id] = CamDir[id] ^ CamLeft[id];

	//------------------------------------------------------------------------
	// calculate the force from inputs
	//------------------------------------------------------------------------
	Vector Force(0, 0, 0);
	Force += CamLeft[id] * CamMove[id].x;
	Force += CamDir [id] * CamMove[id].z;
	Force += Vector(0.0f, CamMove[id].y, 0.0f);


 	if (CameraSphereID[id] != -1)
	{
		GameAddImpulseToObject(CameraSphereID[id], Force * 100.0f);

    	bool bThirdPerson = true;
		
		if (bThirdPerson)
  			CamPos[id] = GameGetObjectPos(CameraSphereID[id]) + CamDir [id] * 30.0f + CamUp[id] * 15.0f;
		else
  			CamPos[id] = GameGetObjectPos(CameraSphereID[id]);
	}
	else
	{
		CamPos[id] += Force;
	}
}


//--------------------------------------------------------------------------
// update all the spheres independently
//--------------------------------------------------------------------------
void Update(void)
{
//--------------------------------------------------------------------------
// dirty windows key management
//--------------------------------------------------------------------------
#ifdef WIN32
	GetKeyboardState(key);
	for(int i = 0; i < 256; i ++)		key[i] = (unsigned char) ((key[i] & (1 << 7)) >> 7); 
	for(int i =   0; i <=   9; i ++)	key[i+48] |= key[i+96]; // bind characters 'a' to 'A', ect...
	for(int i = 'A'; i <= 'Z'; i ++)	key[i+'a' - 'A']  = key[i]; // bind characters 'a' to 'A', ect...
	
#endif

	//--------------------------------------------------------------------------
	// move cameras, and their attached spheres (update cam first, so we can add forces to 
	// attached spheres).
	//--------------------------------------------------------------------------
	for(int i = 0; i < 2; i ++)
	{
		UpdateCamera(i);
	}
	old_mouse_y = mouse_y;
	old_mouse_x = mouse_x;


	//--------------------------------------------------------------------------
	// Update spehre physics, with collisions
	//--------------------------------------------------------------------------
	GameUpdate();

	
	
	//--------------------------------------------------------------------------
	// clear key buffer
	//--------------------------------------------------------------------------
	for(int i = 0; i < 256; i ++) 
		key[i] = 0;
}


float fRadius = 1000.0f;
int glStarList = -1;
enum { eNumStars = 2000 };

void RenderSky()
{
	const float two_pi = (float) atan(1) * 8.0f;

	if (!glIsList(glStarList))
	{
		glStarList = glGenLists(1);

		glNewList(glStarList, GL_COMPILE);

		glBegin(GL_POINTS);

		for (int i = 0; i < eNumStars; i ++)
		{
			float latitude  = frand(two_pi);
			float longitude = frand(two_pi);
			
			Vector Rad(frand(fRadius * 0.2f) + fRadius, frand(fRadius * 0.2f) + fRadius, frand(fRadius * 0.2f) + fRadius);

			Vector Pos(	(float) cos(latitude) * (float) cos(longitude) * Rad.x, 
						(float) sin(latitude) * Rad.y, 
						(float) cos(latitude) * (float) sin(longitude) * Rad.z);

			Vector Norm = Pos; Norm.Normalise();

			glNormal3f (Norm.x, Norm.y, Norm.z);
			glVertex3fv(&Pos.x);
		}
		glEnd();

		glEndList();
	}

	SetMaterial(2, 1.0f);

	glCallList(glStarList);
}

//---------------------------------------------
// setup the camera for rendering and collision
//---------------------------------------------
void RenderCamera(int id)
{
	float x =  -(CamPos[id] * CamLeft[id]);
	float y =  -(CamPos[id] * CamUp  [id]);
	float z =  -(CamPos[id] * CamDir [id]);

	//-----------------------------------------------------------------
	// the inverse of the camera position matrix, to render objects 
	// in camera space
	//-----------------------------------------------------------------
	float mat[16] = { CamLeft[id].x,		CamUp[id].x,	CamDir[id].x,			0.0f,
					  CamLeft[id].y,		CamUp[id].y,	CamDir[id].y,			0.0f,
					  CamLeft[id].z,		CamUp[id].z,	CamDir[id].z,			0.0f,
					  x,					y,				z,						1.0f };
	
	//-----------------------------------------------------------------
	// Setup the infinite projection matrix, just for a laugh
	//-----------------------------------------------------------------
	float vpratio = 1.0f;

	if (eNumCameras > 1)
		vpratio = CameraViewportSize[id].x / CameraViewportSize[id].y;
	
	float fov    = CameraFOV[id];
	float nearp  = 0.1f;
	float aspect = 4.0f / 3.0f * vpratio;

	float pinf[4][4] = {	{ 0, 0, 0, 0 },
							{ 0, 0, 0, 0 },
							{ 0, 0, 0, 0 },
							{ 0, 0, 0, 0 } };
	
	pinf[0][0] = (float) atan(fov) / aspect;
	pinf[1][1] = (float) atan(fov);
	pinf[3][2] = -2.0f * nearp;
	pinf[2][2] = -1.0f;
	pinf[2][3] = -1.0f;

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glLoadMatrixf(&pinf[0][0]);

	//-----------------------------------------------------------------
	// Setup the model view matrix
	//-----------------------------------------------------------------
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glMultMatrixf(mat);
	
	//-----------------------------------------------------------------
	// Setup Viewport (which part of the screen to render the scene).
	//-----------------------------------------------------------------
	if (eNumCameras > 1)
	{
		glViewport(	(int)(CameraViewportPos [id].x * screen_width), 
					(int)(CameraViewportPos [id].y * screen_height), 
					(int)(CameraViewportSize[id].x * screen_width), 
					(int)(CameraViewportSize[id].y * screen_height));
	}
	else
	{
		glViewport(	0, 0, screen_width, screen_height);
	}


	//-----------------------------------------------------------------
	// render sky
	//-----------------------------------------------------------------
	RenderSky();
	
	GameRender();
}


//--------------------------------------------------------------------------
// render simulation
//--------------------------------------------------------------------------
void Render(void)
{
	//--------------------------------------------------------------------------
	// render stuff
	//--------------------------------------------------------------------------
	glClearColor(0.01f, 0.2f, 0.08f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	Update();

	//--------------------------------------------------------------------------
	// render cameras
	//--------------------------------------------------------------------------
	for(int i = 0; i < eNumCameras; i ++)
		RenderCamera(i);

	glutSwapBuffers();
}
 

//--------------------------------------------------------------------------
// Update & render simulation
//--------------------------------------------------------------------------
void Timer(int t)
{
	Render();

	glutTimerFunc(t, Timer, (int)(100.0f / dbg_updatefps));
}

void Keyboard(unsigned char k, int x, int y)
{
	key[k] = 1; // compared to windows asynch keys, the repeated inputs are very slow

	//---------------------------------------------
	// Initialise the simulation
	//---------------------------------------------
	if (k == 'r' || k == 'R')
		Init();
}

void Mouse(int Button, int State, int x, int y)
{
	mouse_button = 0;

	if (Button == GLUT_LEFT_BUTTON)
	{
		if (State == GLUT_DOWN)
		{
			mouse_button = 1;
		}
	}
	
	if (Button == GLUT_RIGHT_BUTTON)
	{
		if (State == GLUT_DOWN)
		{
			mouse_button = 2;
		}
	}

	old_mouse_y = mouse_y;
	old_mouse_x = mouse_x;

	mouse_y = y;
	mouse_x = x;
}

void Motion(int x, int y)
{
	old_mouse_y = mouse_y;
	old_mouse_x = mouse_x;

	mouse_y = y;
	mouse_x = x;
}
void PassiveMotion(int x, int y)
{
	mouse_y = y;
	mouse_x = x;
	old_mouse_y = mouse_y;
	old_mouse_x = mouse_x;
}

//--------------------------------------------------------------------------
// window management
//--------------------------------------------------------------------------
void Reshape(int w, int h)
{
	screen_width  = w;
	screen_height = h;
}

/*
bool EnterFullscreen()
{
	char mode_str[64];
	sprintf(mode_str, "%dx%d:%d@%d", screen_width, screen_height, screen_bpp, screen_hz);

	glutGameModeString(mode_str);

	if (glutGameModeGet(GLUT_GAME_MODE_POSSIBLE))
		return false;
	
	glutEnterGameMode();
	
	screen_width  = glutGameModeGet( GLUT_GAME_MODE_WIDTH );
	screen_height = glutGameModeGet( GLUT_GAME_MODE_WIDTH );
	screen_bpp    = glutGameModeGet( GLUT_GAME_MODE_PIXEL_DEPTH );
	screen_hz     = glutGameModeGet( GLUT_GAME_MODE_REFRESH_RATE );

	return true;
}
/**/

bool EnterWindow()
{
	glutInitWindowSize		(screen_width, screen_height);
	glutInitWindowPosition	(0, 0);
	glutCreateWindow		("swept spheres vs. triangles demo");
	glutReshapeFunc			(Reshape);
	
	return true;
}

//--------------------------------------------------------------------------
// main loop
//--------------------------------------------------------------------------
int dmain(int argc, char** argv)
{
	printf ("3D Pong / breakout collision demo.\n");
	printf ("---------------------------------.\n");
	printf ("performs AABox/sphere tests, with added physics.\n");
	printf ("collision response based on a simple extend reflexion model.\n");
	printf ("press 'r' to reset the simulation.\n");
	printf ("'a', 's', 'w', 'd', 'q', 'z' control the camera movement.\n");
	printf ("hold mouse1/2 to move one of the camera.\n");
	printf ("comments / rants, email at olivierrenault@hotmail.com.\n");
	printf ("Enjoy :)\n");
	printf ("---------------------------.\n");
	printf ("- Oli.\n");
	printf ("---------------------------.\n");
	printf ("possible future extensions : \n");
	printf ("--------------------------- \n");
	printf (" - Triangle mesh collision. \n");
	printf (" - Swept volume collision tests. \n");



	dbg_seed = clock();

	srand(dbg_seed);

	//--------------------------------------------------------------------------
	// OpenGL / GLUT init
	//--------------------------------------------------------------------------
    glutInit( &argc, argv );
	glutInitDisplayMode		(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
	
//	if (!EnterFullscreen())
	EnterWindow();

	glShadeModel	(GL_SMOOTH);
	glEnable		(GL_NORMALIZE);
	glEnable		(GL_DEPTH_TEST);
	glEnable		(GL_CULL_FACE);
	glDisable		(GL_LIGHTING);
	glEnable		(GL_BLEND);
	glBlendFunc		(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	float GlobalAmbient[] = { 0.3f, 0.3f, 0.3f, 1.0f };
	float LightAmbient [] = { 0.2f, 0.2f, 0.2f, 1.0f };
	float LightSpecular[] = { 0.7f, 0.7f, 0.7f, 1.0f };
	float LightDiffuse [] = { 0.5f, 0.5f, 0.5f, 1.0f };
	float LightPos     [] = { 0.0f, 60.0f, 0.0f, 0.0f };
	
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, GlobalAmbient);
	glLightfv(GL_LIGHT0, GL_POSITION, LightPos);
	glLightfv(GL_LIGHT0, GL_DIFFUSE,  LightDiffuse);
	glLightfv(GL_LIGHT0, GL_SPECULAR, LightSpecular);
	glLightfv(GL_LIGHT0, GL_AMBIENT,  LightSpecular);
	
	glutDisplayFunc			(Render);
	glutTimerFunc			(0, Timer, (int)(100.0f / dbg_updatefps));
	glutKeyboardFunc		(Keyboard);
	glutMouseFunc			(Mouse);
	glutPassiveMotionFunc	(PassiveMotion);
	glutMotionFunc			(Motion);

	Init					();
	glutMainLoop			();
	
	return (0);
}



/*
 Leitor-OBJ-MTL-TGA-FCG: Visualizador de modelos simples com rotação utilizando as teclas W,A,S,D
 Files: main.cpp, glm.h, glm.cpp, glmimg.cpp, Texture.cpp, Texture.h, vector3f.h + Esfera/ball.obj,ball.mtl,orange3.tga
 Last update: 29/09/2015
 */

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#include <stdlib.h>
#include <stdio.h>

#include "glm.h"
#include "vector3f.h"

#define WINDOW_WIDTH 800
#define WINDOW_HEIGHT 600

#define PERSPECTIVE 0
#define ORTHO 1

#define PI 3.14159265

#define INFINITO 1 // 1 to see the lights if activated

#define MOVEMENT_ROTATION_OBJECT 5//0.5
#define MOVEMENT_SCALE_OBJECT 0.1//0.05

GLMmodel* modelEsfera;

GLboolean projection; // ORTHO | PERSPECTIVE
GLfloat fAspect;

vector3f eye;

GLfloat angleUpDown;
GLfloat angleLeftRight;

GLfloat roty;
GLfloat rotx;
#include <string.h>
bool C3DObject_Load_New(const char *pszFilename, GLMmodel **model)
{
    char aszFilename[256];
    strcpy(aszFilename, pszFilename);

    if (*model) {

    free(*model);
    *model = NULL;
    }

    *model = glmReadOBJ(aszFilename);
    if (!(*model))
    return false;

    glmUnitize(*model);
    //glmScale(model,sFactor); // USED TO SCALE THE OBJECT
    glmFacetNormals(*model);
    glmVertexNormals(*model, 90.0);

    return true;
}

/* GLUT callback Handlers */

static void resize(int width, int height)
{
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    if(projection == PERSPECTIVE)
        gluPerspective(60,fAspect,0.001,1000);
    else
        glOrtho(-5, 5, -5, 5, -3000, 3000);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(eye.x,eye.y,eye.z, // EYE
              0,0,0, // LOOK
              0,1,0); // CAMERA UP
}

static void display(void)
{
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(eye.x,eye.y,eye.z, // EYE
              0,0,0, // LOOK
              0,1,0); // CAMERA UP

    GLfloat light_position0[4]={0, INFINITO, 0, 0.0};
    GLfloat light_position1[4]={0, 0, INFINITO, 0.0};
    GLfloat light_position2[4]={INFINITO, 0, 0, 0.0};
    glLightfv(GL_LIGHT0, GL_POSITION, light_position0);
    glLightfv(GL_LIGHT1, GL_POSITION, light_position1);
    glLightfv(GL_LIGHT2, GL_POSITION, light_position2);

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    // OBJECT
    glPushMatrix();
        glRotatef(angleUpDown,1,0,0);
        glRotatef(angleLeftRight,0,1,0);
        glmDraw(modelEsfera, GLM_SMOOTH | GLM_MATERIAL | GLM_TEXTURE);
    glPopMatrix();

    glutSwapBuffers();
}

/**
Key press event handler
*/
void onKeyDown(unsigned char key, int x, int y) {

	switch (key) {
	    // rotate and scale the model
		case 'w':
        case 'W':
			angleUpDown-=MOVEMENT_ROTATION_OBJECT;
			break;
		case 's':
        case 'S':
			angleUpDown+=MOVEMENT_ROTATION_OBJECT;
			break;
		case 'a':
        case 'A':
			angleLeftRight-=MOVEMENT_ROTATION_OBJECT;
			break;
		case 'd':
        case 'D':
			angleLeftRight+=MOVEMENT_ROTATION_OBJECT;
			break;
        case 27:
			exit(0);
			break;
		default:
			break;
	}

	//glutPostRedisplay();
}

/**
Key release event handler
*/
void onKeyUp(unsigned char key, int x, int y) {
//	switch (key) {
//		default:
//			break;
//	}

	//glutPostRedisplay();
}

static void timer(int value)
{
    glutPostRedisplay();
    glutTimerFunc(1,timer, 1);
}

static void idle(void)
{
    glutPostRedisplay();
}

void initialize()
{
    projection = PERSPECTIVE; // ORTHO | PERSPECTIVE
    fAspect = (GLfloat)WINDOW_WIDTH/(GLfloat)WINDOW_HEIGHT;

    eye.set(3.0,1.0,3.0);

    angleUpDown=0;
    angleLeftRight=0;

    roty = 0.0f;
    rotx = 90.0f;

    fAspect = (GLfloat)WINDOW_WIDTH/(GLfloat)WINDOW_HEIGHT;

    GLfloat angleUp = 0;
    GLfloat angleDown = 0;
    GLfloat angleLeft = 0;
    GLfloat angleRight = 0;

    // fourth parameter: 1 -> finite distance, 0 -> inifinite distance
    glClearColor (1.0, 1.0, 1.0, 0.0);

    GLfloat ambient_light[4]={0.0,0.0,0.0,1.0};
	GLfloat diffuse_light[4]={1.0,1.0,1.0,1.0};	   // "cor"
	GLfloat specular_light[4]={1.0,1.0,1.0,1.0};// "brilho"

    glLightfv(GL_LIGHT0, GL_AMBIENT, ambient_light);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse_light );
	glLightfv(GL_LIGHT0, GL_SPECULAR, specular_light );

	glLightfv(GL_LIGHT1, GL_AMBIENT, ambient_light);
	glLightfv(GL_LIGHT1, GL_DIFFUSE, diffuse_light );
	glLightfv(GL_LIGHT1, GL_SPECULAR, specular_light );

	glLightfv(GL_LIGHT2, GL_AMBIENT, ambient_light);
	glLightfv(GL_LIGHT2, GL_DIFFUSE, diffuse_light );
	glLightfv(GL_LIGHT2, GL_SPECULAR, specular_light );

   glEnable(GL_LIGHTING);
   glEnable(GL_LIGHT0);
   glEnable(GL_LIGHT1);
   glEnable(GL_LIGHT2);

   glEnable(GL_DEPTH_TEST);

}

/* Program entry point */

int main(int argc, char *argv[])
{
    glutInit(&argc, argv);
    glutInitWindowSize(WINDOW_WIDTH,WINDOW_HEIGHT);
    glutInitWindowPosition(0,0);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);

    glutCreateWindow("OBJ Loader - GLM + GLMIMG + TGA TEXTURE");

    C3DObject_Load_New("Mario/mk_kart.obj",&modelEsfera);

    glutReshapeFunc(resize);
    glutDisplayFunc(display);

	glutKeyboardFunc(onKeyDown);
	glutKeyboardUpFunc(onKeyUp);
    //glutIdleFunc(idle);
    glutTimerFunc(1,timer,1);

    initialize();

    glutMainLoop();

    return EXIT_SUCCESS;
}

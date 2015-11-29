//
//  main.m
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#include <stdlib.h>
#include <stdio.h>
#include "string.h"

#include "glm.hpp"
#include "vector3f.hpp"

#define WINDOW_WIDTH ((GLfloat)800)
#define WINDOW_HEIGHT ((GLfloat)600)

#define PI 3.14159265

#define INFINITO 1 // 1 to see the lights if activated

#define MOVEMENT_ROTATION_OBJECT 5//0.5
#define MOVEMENT_SCALE_OBJECT 0.1//0.05
#include "GameScene.h"


GameScene* scene;

/* GLUT callback Handlers */

static void resize(int width, int height) {
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    float fAspect = WINDOW_WIDTH/WINDOW_HEIGHT;
    
//    if(projection == PERSPECTIVE)
        gluPerspective(45,fAspect,0.001,1000);
//    else
//        glOrtho(-5, 5, -5, 5, -3000, 3000);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
//    gluLookAt(eye.x,eye.y,eye.z, // EYE
//              0,0,0, // LOOK
//              0,1,0); // CAMERA UP
}

static void display(void) {
    
    glClearColor(0.1f, 0.2f, 0.8f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    GLfloat light_position0[4]={0, INFINITO, 0, 0.0};
    GLfloat light_position1[4]={0, 0, INFINITO, 0.0};
    GLfloat light_position2[4]={INFINITO, 0, 0, 0.0};
    glLightfv(GL_LIGHT0, GL_POSITION, light_position0);
    glLightfv(GL_LIGHT1, GL_POSITION, light_position1);
    glLightfv(GL_LIGHT2, GL_POSITION, light_position2);
    

    
    
    glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    glClear(GL_DEPTH_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45, WINDOW_WIDTH/WINDOW_HEIGHT, 0.001, 1000);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    [scene.camera renderCamera];
    [scene render];

    
    glViewport(0, 0, WINDOW_WIDTH/2, WINDOW_HEIGHT/2);
    glClear(GL_DEPTH_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45, WINDOW_WIDTH/WINDOW_HEIGHT, 0.001, 1000);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    [scene.camera renderCamera];
    [scene render];
    
    glutSwapBuffers();
}



/**
 Key press event handler
 */
void onKeyDown(unsigned char key, int x, int y) {
    switch (key) {
        case 'w':
        case 'W':
            scene.pressedKey_forward = TRUE;
            break;
        case 's':
        case 'S':
            scene.pressedKey_backwards = TRUE;
            break;
        case 'a':
        case 'A':
            scene.pressedKey_left = TRUE;
            break;
        case 'd':
        case 'D':
            scene.pressedKey_right = TRUE;
            break;
        default:
            break;
    }
}

/**
 Key release event handler
 */
void onKeyUp(unsigned char key, int x, int y) {
    switch (key) {
        case 'w':
        case 'W':
            scene.pressedKey_forward = FALSE;
            break;
        case 's':
        case 'S':
            scene.pressedKey_backwards = FALSE;
            break;
        case 'a':
        case 'A':
            scene.pressedKey_left = FALSE;
            break;
        case 'd':
        case 'D':
            scene.pressedKey_right = FALSE;
            break;
        case 'v':
        case 'V':
            [scene.camera changeCameraMode];
            break;
        case 32:
            [scene.playerCar action];
            break;
        case 27:
            exit(0);
            break;
        default:
            break;
    }
}

static void timer(int value) {
//    int timeSinceStart = glutGet(GLUT_ELAPSED_TIME);
//    int deltaTime = timeSinceStart - oldTimeSinceStart;
//    oldTimeSinceStart = timeSinceStart;
    
    [scene updateWithDelta:1];
    glutPostRedisplay();
    glutTimerFunc(1, timer, 1);
}

static void idle(void)
{
    glutPostRedisplay();
}

void initialize()
{
    // fourth parameter: 1 -> finite distance, 0 -> inifinite distance
    glClearColor (1.0, 1.0, 1.0, 0.0);
    
    GLfloat ambient_light[4]={1.0,1.0,1.0,1.0};
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
    
    glutCreateWindow("Mario Kart - Txai Wieser");
    scene = [[GameScene alloc] init];
    
    glutReshapeFunc(resize);
    glutDisplayFunc(display);
    
    glutKeyboardFunc(onKeyDown);
    glutKeyboardUpFunc(onKeyUp);
    glutIdleFunc(idle);
    glutTimerFunc(1, timer, 1);
    initialize();
    
    glutMainLoop();
    
    return EXIT_SUCCESS;
}

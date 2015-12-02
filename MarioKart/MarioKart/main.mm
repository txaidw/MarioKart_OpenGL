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


#define INFINITO 1 // 1 to see the lights if activated
#include "GameScene.h"


GameScene* scene;

/* GLUT callback Handlers */

GLfloat WINDOW_WIDTH;
GLfloat WINDOW_HEIGHT;

static void resize(int width, int height) {
    WINDOW_WIDTH = width;
    WINDOW_HEIGHT = height;
}

static void display(void) {
    
    glClearColor(0.1f, 0.2f, 0.8f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    glClear(GL_DEPTH_BUFFER_BIT);
    [scene.playerCar.frontCamera renderCamera];
    [scene render];
    [scene renderHUD];

    glViewport(WINDOW_WIDTH*(1/2.0 - 1/8.0), WINDOW_HEIGHT-(20 +WINDOW_WIDTH/15.0), WINDOW_WIDTH/4.0, WINDOW_WIDTH/15.0);
    glClear(GL_DEPTH_BUFFER_BIT);
    [scene.playerCar.backCamera renderCamera];
    [scene render];
    
    glViewport(20, 20, WINDOW_HEIGHT/4, WINDOW_HEIGHT/4);
    glClear(GL_DEPTH_BUFFER_BIT);
    [scene.trackCamera renderCamera];
    [scene prepareForTrackCamera];
    [scene render];
    [scene backFromTrackCamera];

    
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
            [scene.playerCar.frontCamera changeCameraMode];
            break;
        case 32:
            [scene.playerCar fireAction];
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
    [scene collisionCheck];
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
    WINDOW_WIDTH = 800;
    WINDOW_HEIGHT = 600;
    
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

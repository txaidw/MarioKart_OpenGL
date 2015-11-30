//
//  GameScene.m
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "GameScene.h"

#import "Pista.h"
#import "CarNode.h"
#import "QmarkBox.h"

#import "game main.h"
#import "glm.hpp"

@interface GameScene ()

@property Pista *pista;
@property CarNode *testCar;

@end

@implementation GameScene {
    GLuint n1;
    GLuint n2;
    GLuint n3;
    GLuint n4;
    GLuint n5;
    GLuint n6;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.trackCamera = [[TWGLCamera alloc] init];
        [self addChild:self.trackCamera];
        self.trackCamera.positionY = 999;
        self.trackCamera.rotationX = 90;
        [self.trackCamera setOrtho];

        
        _pista = [[Pista alloc] init];
        [self addChild:_pista];
        
        _testCar = [[CarNode alloc] init];
        _testCar.playerController = self;
        _testCar.positionX = 375;
        [self addChild:_testCar];
        
        QmarkBox *centerBox = [[QmarkBox alloc] init];
        [self addChild:centerBox];
        centerBox.positionY = 50;
        centerBox.scale = 20;
        centerBox.action = ^(TWGLNode *node, GLfloat dt) {
            node.rotationX += 0.2*dt;
            node.rotationY += 0.2*dt;
            node.rotationZ += 0.2*dt;
        };
        
        self.playerCar = _testCar;
        
        [self generateRandomBoxes];
        
        GLfloat ww, hh;
        
        n6 = glmLoadTexture("MarioKart/Models/SkyBox/floor.tga", false, false, false, true, &ww, &hh);
        n5 = glmLoadTexture("MarioKart/Models/SkyBox/top.tga", false, false, false, true, &ww, &hh);
        n1 = n2 = n3 = n4 = glmLoadTexture("MarioKart/Models/SkyBox/wall.tga", false, false, false, true, &ww, &hh);
    }
    return self;
}

- (void)generateRandomBoxes {
    int boxes = 6;
    
    for(int i=0; i<boxes; i++) {
        QmarkBox *b = [[QmarkBox alloc] init];
        b.positionX = 375 + 10*cos(rand());
        b.positionZ = (750)*(i/(boxes-1.0)) - 375;
        [self addChild:b];
    }

    for(int i=0; i<boxes; i++) {
        QmarkBox *b = [[QmarkBox alloc] init];
        b.positionX = -375 + 10*cos(rand());
        b.positionZ = (750)*(i/(boxes-1.0)) - 375;
        [self addChild:b];
    }

    for(int i=0; i<boxes; i++) {
        QmarkBox *b = [[QmarkBox alloc] init];
        b.positionZ = 375 + 10*cos(rand());
        b.positionX = (750)*(i/(boxes-1.0)) - 375;
        [self addChild:b];
    }
    
    for(int i=0; i<boxes; i++) {
        QmarkBox *b = [[QmarkBox alloc] init];
        b.positionZ = -375 + 10*cos(rand());
        b.positionX = (750)*(i/(boxes-1.0)) - 375;
        [self addChild:b];
    }
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
}


- (void)render {
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    GLfloat INFINITO = 1;
    GLfloat light_position0[4]={0, INFINITO, 0, 0.0};
    GLfloat light_position1[4]={0, 0, INFINITO, 0.0};
    GLfloat light_position2[4]={INFINITO, 0, 0, 0.0};
    glLightfv(GL_LIGHT0, GL_POSITION, light_position0);
    glLightfv(GL_LIGHT1, GL_POSITION, light_position1);
    glLightfv(GL_LIGHT2, GL_POSITION, light_position2);
    [self renderSky];
    [super render];
}

- (void)renderSky {
    // Store the current matrix

    
    float size = 1000;
    glPushMatrix();
    
    // Enable/Disable features
    glPushAttrib(GL_ENABLE_BIT);
    glEnable(GL_TEXTURE_2D);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_LIGHTING);
    glDisable(GL_BLEND);
    
    // Just in case we set all vertices to white.
    glColor4f(1,1,1,1);
    
    // Render the front quad
    glBindTexture(GL_TEXTURE_2D, n1);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f(  0.5*size, -0.0*size, -0.5*size );
    glTexCoord2f(1, 0); glVertex3f( -0.5*size, -0.0*size, -0.5*size );
    glTexCoord2f(1, 1); glVertex3f( -0.5*size,  1.0*size, -0.5*size );
    glTexCoord2f(0, 1); glVertex3f(  0.5*size,  1.0*size, -0.5*size );
    glEnd();
    
    // Render the left quad
    glBindTexture(GL_TEXTURE_2D, n2);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f(  0.5*size, -0.0*size,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size, -0.0*size, -0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size,  1.0*size, -0.5*size );
    glTexCoord2f(0, 1); glVertex3f(  0.5*size,  1.0*size,  0.5*size );
    glEnd();
    
    // Render the back quad
    glBindTexture(GL_TEXTURE_2D, n3);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f( -0.5*size, -0.0*size,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size, -0.0*size,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size,  1.0*size,  0.5*size );
    glTexCoord2f(0, 1); glVertex3f( -0.5*size,  1.0*size,  0.5*size );
    
    glEnd();
    
    // Render the right quad
    glBindTexture(GL_TEXTURE_2D, n4);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f( -0.5*size, -0.0*size, -0.5*size );
    glTexCoord2f(1, 0); glVertex3f( -0.5*size, -0.0*size,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f( -0.5*size,  1.0*size,  0.5*size );
    glTexCoord2f(0, 1); glVertex3f( -0.5*size,  1.0*size, -0.5*size );
    glEnd();
    
    // Render the top quad
    glBindTexture(GL_TEXTURE_2D, n5);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 1); glVertex3f( -0.5*size,  1.0*size, -0.5*size );
    glTexCoord2f(0, 0); glVertex3f( -0.5*size,  1.0*size,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size,  1.0*size,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size,  1.0*size, -0.5*size );
    glEnd();
    
    // Render the bottom quad
    glBindTexture(GL_TEXTURE_2D, n6);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f( -0.5*size, -0.0*size, -0.5*size );
    glTexCoord2f(0, 1); glVertex3f( -0.5*size, -0.0*size,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size, -0.0*size,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size, -0.0*size, -0.5*size );
    glEnd();
    
    // Restore enable bits and matrix
    glPopAttrib();
    glPopMatrix();
}

@end

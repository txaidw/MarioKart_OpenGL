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
        _pista = [[Pista alloc] init];
        [self addChild:_pista];
        
        _testCar = [[CarNode alloc] init];
        _testCar.playerController = self;
        [_testCar addChild:self.camera];
        _testCar.positionX = 450;
        [self addChild:_testCar];
        
        QmarkBox *m = [[QmarkBox alloc] init];
        [self addChild:m];
        m.positionY = 2;
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
    int boxes = 5;
    
    for(int i=0; i<boxes; i++) {
        QmarkBox *b = [[QmarkBox alloc] init];
        b.positionX = 450 + 10*cos(rand());
        b.positionZ = (510+240)*(i/(boxes-1.0)) - 510;
        [self addChild:b];
    }

    for(int i=0; i<boxes; i++) {
        QmarkBox *b = [[QmarkBox alloc] init];
        b.positionX = -300 + 10*cos(rand());
        b.positionZ = (510+240)*(i/(boxes-1.0)) - 510;
        [self addChild:b];
    }

    for(int i=0; i<boxes; i++) {
        QmarkBox *b = [[QmarkBox alloc] init];
        b.positionZ = 240 + 10*cos(rand());
        b.positionX = (300+450)*(i/(boxes-1.0)) - 300;
        [self addChild:b];
    }
    
    for(int i=0; i<boxes; i++) {
        QmarkBox *b = [[QmarkBox alloc] init];
        b.positionZ = -510 + 10*cos(rand());
        b.positionX = (300+450)*(i/(boxes-1.0)) - 300;
        [self addChild:b];
    }
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
}

- (void)render {
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
    glTexCoord2f(0, 0); glVertex3f(  0.5*size, -0.5*size, -0.5*size );
    glTexCoord2f(1, 0); glVertex3f( -0.5*size, -0.5*size, -0.5*size );
    glTexCoord2f(1, 1); glVertex3f( -0.5*size,  0.5*size, -0.5*size );
    glTexCoord2f(0, 1); glVertex3f(  0.5*size,  0.5*size, -0.5*size );
    glEnd();
    
    // Render the left quad
    glBindTexture(GL_TEXTURE_2D, n2);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f(  0.5*size, -0.5*size,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size, -0.5*size, -0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size,  0.5*size, -0.5*size );
    glTexCoord2f(0, 1); glVertex3f(  0.5*size,  0.5*size,  0.5*size );
    glEnd();
    
    // Render the back quad
    glBindTexture(GL_TEXTURE_2D, n3);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f( -0.5*size, -0.5*size,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size, -0.5*size,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size,  0.5*size,  0.5*size );
    glTexCoord2f(0, 1); glVertex3f( -0.5*size,  0.5*size,  0.5*size );
    
    glEnd();
    
    // Render the right quad
    glBindTexture(GL_TEXTURE_2D, n4);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f( -0.5*size, -0.5*size, -0.5*size );
    glTexCoord2f(1, 0); glVertex3f( -0.5*size, -0.5*size,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f( -0.5*size,  0.5*size,  0.5*size );
    glTexCoord2f(0, 1); glVertex3f( -0.5*size,  0.5*size, -0.5*size );
    glEnd();
    
    // Render the top quad
    glBindTexture(GL_TEXTURE_2D, n5);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 1); glVertex3f( -0.5*size,  0.5*size, -0.5*size );
    glTexCoord2f(0, 0); glVertex3f( -0.5*size,  0.5*size,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size,  0.5*size,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size,  0.5*size, -0.5*size );
    glEnd();
    
    // Render the bottom quad
    glBindTexture(GL_TEXTURE_2D, n6);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f( -0.5*size, -0.5*size, -0.5*size );
    glTexCoord2f(0, 1); glVertex3f( -0.5*size, -0.5*size,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size, -0.5*size,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size, -0.5*size, -0.5*size );
    glEnd();
    
    // Restore enable bits and matrix
    glPopAttrib();
    glPopMatrix();
}

GLuint LoadTexture( const char * filename, int width, int height) {
    GLuint texture;
    unsigned char * data;
    FILE* file;
    
    file = fopen( filename, "rb" );
    if ( file == NULL ) return 0;
    data = (unsigned char *)malloc( width * height * 3 );
    fread( data, width * height * 3, 1, file );
    fclose( file );
    
    glGenTextures( 1, &texture );
    glBindTexture( GL_TEXTURE_2D, texture );
    glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );
    
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR_MIPMAP_LINEAR );
    
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
    
    gluBuild2DMipmaps( GL_TEXTURE_2D, 3, width, height, GL_RGB, GL_UNSIGNED_BYTE, data );
    free(data);
    return texture;
}
@end

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
#import "SkyBox.h"

#import "glm.hpp"


@interface GameScene ()

@property Pista *pista;
@property NSMutableArray *cars;
@property SkyBox *sky;
@property int playerPosition;
@property BOOL gameIsFinished;
@end

@implementation GameScene
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
        

        float dist = 6;
        float line = 100;
        
        CarNode *mario = [[CarNode alloc] initWithModelNamed:CAR_CHARACTER_MARIO];
        mario.positionX = 375 - dist/2;
        mario.positionZ = line;
        mario.playerController = self;
        [self addChild:mario];
        self.playerCar = mario;

        CarNode *peach = [[CarNode alloc] initWithModelNamed:CAR_CHARACTER_PEACH];
        peach.positionX = 375 + dist/2;
        peach.positionZ = line;
        [self addChild:peach];

        CarNode *luigi = [[CarNode alloc] initWithModelNamed:CAR_CHARACTER_LUIGI];
        luigi.positionX = 375 + dist/2;
        luigi.positionZ = line - dist;
        [self addChild:luigi];
        
        CarNode *bowser = [[CarNode alloc] initWithModelNamed:CAR_CHARACTER_BOWSER];
        bowser.positionX = 375 - dist/2;
        bowser.positionZ = line - dist;
        [self addChild:bowser];
        
        _cars = [[NSMutableArray alloc] initWithObjects:mario, peach, luigi, bowser, nil];
        
        QmarkBox *centerBox = [[QmarkBox alloc] init];
        [self addChild:centerBox];
        centerBox.positionY = 50;
        centerBox.scale = 20;
        centerBox.action = ^(TWGLNode *node, GLfloat dt) {
            node.rotationX += 0.2*dt;
            node.rotationY += 0.2*dt;
            node.rotationZ += 0.2*dt;
        };
        
        
        [self generateRandomBoxes];
        
        _sky = [[SkyBox alloc] init];
        self.playerPosition = 1;
        
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
    NSArray *positions = [_cars sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey: @"self.trackAbsoluteAngle" ascending: FALSE]]];
    
    self.playerPosition = [positions indexOfObject:self.playerCar]+1;
}



- (void)initialize {
    // fourth parameter: 1 -> finite distance, 0 -> inifinite distance
    
}

- (void)render {
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    [self renderHUD];

    [self.sky render];
    [super render];

}


- (void)finishGame {
    _gameIsFinished = TRUE;
}

- (void)renderHUD {

    GLint m_viewport[4]; glGetIntegerv(GL_VIEWPORT, m_viewport);

    glMatrixMode(GL_PROJECTION);    //Select projection matrix
    glPushMatrix();                 //save it
    glLoadIdentity();
    
    glMatrixMode(GL_MODELVIEW);    //Select modelview matrix
    glPushMatrix();                //save it
    glLoadIdentity();
    
    // set up ur glOrtho
    glDisable(GL_TEXTURE_2D);
    glOrtho(m_viewport[0], m_viewport[2], m_viewport[1], m_viewport[3], 0, 1000);

    drawText((self.playerCar.itemNamed == NULL ? @"EMPTY SLOT" : self.playerCar.itemNamed), m_viewport[2]-160, 20);
    
    drawText([NSString stringWithFormat:@"%dº LUGAR", self.playerPosition], m_viewport[2]-160, 50);
    
    if (_gameIsFinished) {
        drawText(@"FIM", m_viewport[2]/2-14, m_viewport[3]/2);
        drawText([NSString stringWithFormat:@"COLOCAÇÃO: %dº LUGAR", self.playerPosition], m_viewport[2]/2-100, m_viewport[3]/2 - 30);

    }
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();                //Restore your old projection matrix
    
    glMatrixMode(GL_MODELVIEW);
    glPopMatrix();               //Restore old modelview matrix
}

void drawText(NSString* name, GLdouble x, GLdouble y)
{
    
    glColor4f(1.0, 1.0, 0.0, 1.0);
    glRasterPos2f(x, y);

    for (int i = 0; i < name.length; ++i) {
        glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, [name characterAtIndex:i]);
    }
}

- (void)prepareForTrackCamera {
    for (CarNode *node in self.cars) {
        [node addChild:node.markerNode];
    }
}

- (void)backFromTrackCamera {
    for (CarNode *node in self.cars) {
        [node removeChild:node.markerNode];
    }
}

@end

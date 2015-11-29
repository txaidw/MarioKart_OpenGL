//
//  TWGLCamera.m
//  MarioKart
//
//  Created by Txai Wieser on 23/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLCamera.h"
#import <GLUT/glut.h>

#define CAMERA_TYPE1_PX 0
#define CAMERA_TYPE1_PY 2.0
#define CAMERA_TYPE1_PZ -3.7

#define CAMERA_TYPE2_PX 0
#define CAMERA_TYPE2_PY 4
#define CAMERA_TYPE2_PZ -10

#define CAMERA_TYPE3_PX 0
#define CAMERA_TYPE3_PY 0.5
#define CAMERA_TYPE3_PZ 1.0

#define CAMERA_TYPES 3
@implementation TWGLCamera {
    int type;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        type = 1;
        [self loadCameraSettings];
    }
    return self;
}

- (void)render {}

- (void)renderCamera {
    float xx = 0, yy = 0, zz = 0, rr = 0;
    float nn, nnn;
    
    [self calculateAbsolutePosition:&xx yy:&yy zz:&zz];
    [self calculateAbsoluteRotation:&nn yy:&rr zz:&nnn];
    
    zz -= self.positionZ;
    zz += self.positionZ*cos(rr*M_PI/180);
    xx += self.positionZ*sin(rr*M_PI/180);
    float distance = 2;
    float px = distance*sin(rr*M_PI/180);
    float pz = distance*cos(rr*M_PI/180);
    gluLookAt(xx, yy, zz, // EYE
              xx+px, yy, zz+pz, // LOOK
              0, 1, 0); // CAMERA UP
}

- (void)changeCameraMode {
    printf("\nCHANGE CAMERA\n");
    type++;
    if (type > CAMERA_TYPES) {
        type = 1;
    }
    [self loadCameraSettings];
}

- (void)loadCameraSettings {
    
    switch (type) {
        case 1:
            self.positionX = CAMERA_TYPE1_PX;
            self.positionY = CAMERA_TYPE1_PY;
            self.positionZ = CAMERA_TYPE1_PZ;
            break;
        
        case 2:
            self.positionX = CAMERA_TYPE2_PX;
            self.positionY = CAMERA_TYPE2_PY;
            self.positionZ = CAMERA_TYPE2_PZ;
            break;
            
        case 3:
            self.positionX = CAMERA_TYPE3_PX;
            self.positionY = CAMERA_TYPE3_PY;
            self.positionZ = CAMERA_TYPE3_PZ;
            break;
            
        default:
            break;
    }
}
@end

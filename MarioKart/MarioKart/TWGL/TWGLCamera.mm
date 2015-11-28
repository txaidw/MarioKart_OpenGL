//
//  TWGLCamera.m
//  MarioKart
//
//  Created by Txai Wieser on 23/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLCamera.h"
#import <GLUT/glut.h>

@implementation TWGLCamera


//- (instancetype)initWithShader:(TWGLShadersReference *)shader {
//    self = [super initWithName:"TWGLDefaultScene" shader:shader];
//    if (self) {
//        self.rotationX = -M_PI/4;
//        self.position = GLKVector3Make(0, 10, 0);
//    }
//    return self;
//}


- (void)render {}

- (void)renderCamera {
    float xx = 0, yy = 0, zz = 0, rr = 0;
    
    TWGLNode *node = self;
    while (node) {
        xx += node.positionX;
        yy += node.positionY;
        zz += node.positionZ;
        rr += node.rotationY;
        node = node.parent;
    }
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
@end

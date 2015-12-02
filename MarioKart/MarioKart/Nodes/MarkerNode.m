//
//  Marker.m
//  MarioKart
//
//  Created by Txai Wieser on 30/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "MarkerNode.h"

@implementation MarkerNode

- (instancetype)initWithModelNamed:(NSString *)named
{
    self = [super init];
    if (self) {
        self.scale = 18;
        
        if ([named isEqualToString:CAR_CHARACTER_MARIO]) {
            self.colorR = 1.0;
        } else if ([named isEqualToString:CAR_CHARACTER_LUIGI]) {
            self.colorG = 1.0;
        } else if ([named isEqualToString:CAR_CHARACTER_PEACH]) {
            self.colorG = 1.0;
            self.colorR = 1.0;
        } else if ([named isEqualToString:CAR_CHARACTER_BOWSER]) {
            self.colorB = 1.0;
        }
        

    }
    return self;
}
//
//- (void)render {
//    glPushMatrix();
//    glTranslatef(self.positionZ, self.positionY, self.positionZ);
//    glRotatef(self.rotationX, 1, 0, 0);
//    glRotatef(self.rotationY, 0, 1, 0);
//    glRotatef(self.rotationZ, 0, 0, 1);
//    glScalef(self.scale, self.scale, self.scale);
//    glColor4f(1,1,0,1);
//    glutSolidSphere(10, 10, 10);
//    glPopMatrix();
//}

- (void)render {
    glPushMatrix();
    glTranslatef(self.positionX, self.positionY, self.positionZ);
    glRotatef(self.rotationX, 1, 0, 0);
    glRotatef(self.rotationY, 0, 1, 0);
    glRotatef(self.rotationZ, 0, 0, 1);
    glScalef(self.scale, self.scale, self.scale);
    
    glColor4f(self.colorR, self.colorG, self.colorB, 1);
    glutSolidSphere(self.scale/10.0, 10, 10);
    glPopMatrix();
}
@end

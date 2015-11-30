//
//  Marker.m
//  MarioKart
//
//  Created by Txai Wieser on 30/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "MarkerNode.h"

@implementation MarkerNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scale = 60;
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
@end

//
//  Missile.m
//  MarioKart
//
//  Created by Txai Wieser on 28/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "Missile.h"

#define MISSILE_VELOCITY 2

@implementation Missile

- (instancetype)init
{
    GLMmodel *aModel = glmReadOBJ("MarioKart/Models/Esfera/ball.obj");
    self = [super initWithModel:aModel];
    if (self) {
        self.hasPhysicsBody = TRUE;
        self.scale = 0.3;
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
    self.rotationZ += 1 *dt;
    self.positionX += MISSILE_VELOCITY * sin(self.rotationY*M_PI/180.0);
    self.positionZ += MISSILE_VELOCITY * cos(self.rotationY*M_PI/180.0);
}

@end

//
//  Trap.m
//  MarioKart
//
//  Created by Txai Wieser on 28/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "Trap.h"

@implementation Trap


- (instancetype)init
{
    GLMmodel *aModel = glmReadOBJ("MarioKart/Models/Esfera/ball.obj");
    self = [super initWithModel:aModel];
    if (self) {
        
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
    self.rotationX -= 4 *dt;
    self.rotationY += 8 *dt;
    self.rotationZ -= 16 *dt;
}


@end

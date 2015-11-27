//
//  CarNode.m
//  MarioKart
//
//  Created by Txai Wieser on 22/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "CarNode.h"

#define ACCELERATION_RATE 0.3
#define DIRECTION_RATE 0.1

@implementation CarNode

- (instancetype)initWithShader:(TWGLShadersReference *)shader
{
    if ((self = [super initWithName:"carNode" shader:shader])) {
//
//        [self loadTexture:@"mushroom.png"];
//        
////        self.rotationY = M_PI;
//        self.rotationX = M_PI_2;
//        self.scale = 0.5;
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    self.rotationY -= self.direction * DIRECTION_RATE;
    CGFloat pX = self.acceleration * ACCELERATION_RATE * sin(self.rotationY);
    CGFloat pZ = self.acceleration * ACCELERATION_RATE * cos(self.rotationY);
    
    GLKVector3 op = self.position;
    self.position = GLKVector3Make(op.x - pX, op.y, op.z - pZ);
}
@end

//
//  TWGLCamera.m
//  MarioKart
//
//  Created by Txai Wieser on 23/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLCamera.h"

@implementation TWGLCamera


- (instancetype)initWithShader:(TWGLShadersReference *)shader {
    self = [super initWithName:"TWGLDefaultScene" shader:shader];
    if (self) {
        self.rotationX = -M_PI/4;
        self.position = GLKVector3Make(0, 10, 0);
    }
    return self;
}
@end

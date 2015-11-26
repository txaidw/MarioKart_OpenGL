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
    self = [super initWithName:"TWGLDefaultScene" shader:nil vertices:0 vertexCount:0];
    if (self) {
        
    }
    return self;
}
@end

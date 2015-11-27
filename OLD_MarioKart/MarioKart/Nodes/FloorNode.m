//
//  FloorNode.m
//  MarioKart
//
//  Created by Txai Wieser on 25/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "FloorNode.h"

@implementation FloorNode

- (instancetype)initWithShader:(TWGLShadersReference *)shader {
    if (self = [super initWithName:"floorNode" shader:shader modelNamed:@"test_plane"]) {
        
    }
    return self;
}

@end
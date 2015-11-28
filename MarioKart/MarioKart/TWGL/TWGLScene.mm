//
//  RWTGameScene.m
//  HelloOpenGL
//
//  Created by Main Account on 3/24/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "TWGLScene.h"

@implementation TWGLScene


- (instancetype)init
{
    self = [super initWithModel:NULL];
    if (self) {
        _camera = [[TWGLCamera alloc] init];
    }
    return self;
}

- (void)render {
    for (TWGLNode *child in self.childrenArray) {
        [child render];
    }
}


@end

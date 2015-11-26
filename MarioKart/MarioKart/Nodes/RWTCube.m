//
//  RWTCube.m
//  HelloOpenGL
//
//  Created by Main Account on 3/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "RWTCube.h"

const GLfloat vertices[72] = {
    // Front
    1, -1, 1,
    1, 1, 1,
    -1, 1, 1,
    -1, -1, 1,
    
    // Back
    -1, -1, -1,
    -1, 1, -1,
    1, 1, -1,
    1, -1, -1,
    
    // Left
    -1, -1, 1,
    -1, 1, 1,
    -1, 1, -1,
    -1, -1, -1,
    
    // Right
    1, -1, -1,
    1, 1, -1,
    1, 1, 1,
    1, -1, 1,
    
    // Top
    1, 1, 1,
    1, 1, -1,
    -1, 1, -1,
    -1, 1, 1,
    
    // Bottom
    1, -1, -1,
    1, -1, 1,
    -1, -1, 1,
    -1, -1, -1
};

const GLubyte indices[36] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 5, 6,
    6, 7, 4,
    // Left
    8, 9, 10,
    10, 11, 8,
    // Right
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20
};

@implementation RWTCube

- (instancetype)initWithShader:(TWGLShadersReference *)shader {
    
    int vc = sizeof(vertices)/sizeof(vertices[0]);
    int ic = sizeof(indices)/sizeof(indices[0]);
    if ((self = [super initWithName:"cube" shader:shader vertices:(GLfloat *)vertices vertexCount:vc inidices:(GLubyte *)indices indexCount:ic])) {

        [self loadTexture:@"dungeon_01.png"];
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    self.rotationY += M_PI/8 * dt;
}

@end

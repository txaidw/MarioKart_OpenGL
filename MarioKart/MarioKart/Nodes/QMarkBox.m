//
//  QMarkBox.m
//  MarioKart
//
//  Created by Txai Wieser on 25/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "QMarkBox.h"
#import "TWGLOBJLoader.h"

@implementation QMarkBox

- (instancetype)initWithShader:(TWGLShadersReference *)shader {
    GLMmodel obj = [TWGLOBJLoader loadOBJ:@"qmark"];
    
    GLfloat *array = [TWGLOBJLoader parseGLMmodel:&obj];
    
    if ((self = [super initWithName:"qmark" shader:shader vertices:array vertexCount:3*124])) {
//        [self loadTexture:@"dungeon_01.png"];
//        self.scale = 0.3;
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
//    self.rotationZ += M_PI/8 * dt;
//    self.rotationX += M_PI/8 * dt;
}

@end

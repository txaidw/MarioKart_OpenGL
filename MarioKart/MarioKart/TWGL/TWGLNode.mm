//
//  TWGLNode.m
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLNode.h"
#import "glm.hpp"

@interface TWGLNode ()

@property GLMmodel *model;
@property NSMutableArray *children;

@end

@implementation TWGLNode

- (instancetype)initWithModel:(GLMmodel *)model
{
    self = [super init];
    if (self) {
        _model = model;
        _children = [[NSMutableArray alloc] init];
        _scale = 1.0;
        _positionX = 0;
        _positionY = 0;
        _positionZ = 0;
        _rotationX = 0;
        _rotationY = 0;
        _rotationZ = 0;

    }
    return self;
}

- (void)render {
    glPushMatrix();
        glTranslatef(_positionX, _positionY, _positionZ);
        glRotatef(_rotationX, 1, 0, 0);
        glRotatef(_rotationY, 0, 1, 0);
        glRotatef(_rotationZ, 0, 0, 1);
        glScalef(_scale, _scale, _scale);
    
        glmDraw(_model, GLM_MATERIAL | GLM_TEXTURE); //GLM_SMOOTH |
    
        for (TWGLNode *child in self.children) {
            [child render];
        }
    glPopMatrix();
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    for (TWGLNode *child in self.children) {
        [child updateWithDelta:dt];
    }
}


- (void)addChild:(TWGLNode *)node {
    [_children addObject:node];
    node.parent = self;
}
- (void)removeChild:(TWGLNode *)node {
    [_children removeObject:node];
    node.parent = NULL;
}

- (NSArray *)childrenArray {
    return _children;
}
@end

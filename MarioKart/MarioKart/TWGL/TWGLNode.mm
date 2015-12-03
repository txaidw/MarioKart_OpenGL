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

@implementation TWGLNode {
    float radius;

}

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
        
        radius = 2;
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
    
    glmDraw(_model, GLM_MATERIAL | GLM_TEXTURE);// | GLM_SMOOTH);
    
        for (TWGLNode *child in self.childrenArray) {
            [child render];
        }
    glPopMatrix();
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    if (self.action) {
        self.action(self, dt);
    }
    for (TWGLNode *child in self.childrenArray) {
        [child updateWithDelta:dt];
    }
}

- (void)didCollideWith:(TWGLNode *)node {
    printf("Collide: %s - %s\n", NSStringFromClass([self class]).UTF8String, NSStringFromClass([node class]).UTF8String);
}

- (void)collisionCheck {
    for (TWGLNode *node in self.childrenArray) {
        [node collisionCheck];
    }
    
    for (TWGLNode *node in self.scene.childrenArray) {
        if ([self isCollidingWith:node]) {
            [self didCollideWith:node];
        }
    }
}

- (BOOL)isCollidingWith:(TWGLNode *)node {
    if (self != node && self.hasPhysicsBody && node.hasPhysicsBody) {

        float distance = [self distanceToNode:node];
        if (distance <= radius) {
            return TRUE;
        } else {
            return FALSE;
        }
    } else {
        return FALSE;
    }
}

- (float)distanceToNode:(TWGLNode *)node {
    float nx, ny, nz;
    [node calculateAbsolutePosition:&nx yy:&ny zz:&nz];
    return [self distanceToPointX:nx y:ny z:nz];
}

- (float)distanceToPointX:(float)nx y:(float)ny z:(float)nz {
    float sx, sy, sz;
    [self calculateAbsolutePosition:&sx yy:&sy zz:&sz];
    float x_diff = sx - nx;
    float y_diff = sy - ny;
    float z_diff = sz - nz;
    return sqrtf(x_diff*x_diff + y_diff*y_diff + z_diff*z_diff);
}

- (void)addChild:(TWGLNode *)node {
    [_children addObject:node];
    node.parent = self;
    node.scene = self.scene;
}
- (void)removeChild:(TWGLNode *)node {
    [_children removeObject:node];
    node.parent = NULL;
    node.scene = NULL;
}
- (void)removeFromParent {
    [self.parent removeChild:self];
}

- (NSArray *)childrenArray {
    return [NSArray arrayWithArray:_children];
}

- (void)calculateAbsoluteRotation:(float *)xx yy:(float *)yy zz:(float *)zz {
    *xx = *yy = *zz = 0;
    TWGLNode *node = self;
    while (node) {
        *xx += node.rotationX;
        *yy += node.rotationY;
        *zz += node.rotationZ;
        node = node.parent;
    }
}
- (void)calculateAbsolutePosition:(float *)xx yy:(float *)yy zz:(float *)zz {
    *xx = *yy = *zz = 0;
    TWGLNode *node = self;
    while (node) {
        *xx += node.positionX;
        *yy += node.positionY;
        *zz += node.positionZ;
        node = node.parent;
    }
}
@end

//
//  TWGLNode.h
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "glm.hpp"

@interface TWGLNode : NSObject

@property float scale;

@property float positionX;
@property float positionY;
@property float positionZ;

@property float rotationX;
@property float rotationY;
@property float rotationZ;

@property BOOL hasPhysicsBody;

@property (weak) TWGLNode *parent;
@property (weak) TWGLNode *scene;

@property (nonatomic, copy) void (^action)(TWGLNode *node, GLfloat dt);

- (instancetype)initWithModel:(GLMmodel *)model;

- (void)render;

- (void)updateWithDelta:(NSTimeInterval)dt;

- (void)addChild:(TWGLNode *)node;
- (void)removeChild:(TWGLNode *)node;
- (NSArray *)childrenArray;

- (void)calculateAbsolutePosition:(float *)xx yy:(float *)yy zz:(float *)zz;
- (void)calculateAbsoluteRotation:(float *)xx yy:(float *)yy zz:(float *)zz;

- (void)collisionCheck;
- (void)didCollideWith:(TWGLNode *)node;
@end

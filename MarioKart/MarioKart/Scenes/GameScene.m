//
//  GameScene.m
//  MarioKart
//
//  Created by Txai Wieser on 22/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "GameScene.h"
#import "Mushroom.h"
#import "RWTCube.h"

@interface GameScene ()

@property (strong, nonatomic) TWGLNode *mushroom;

@end

@implementation GameScene {
    TWGLNode *xCube;
    TWGLNode *yCube;
    TWGLNode *zCube;
}

- (instancetype)initWithShader:(TWGLShadersReference *)shader {
    self = [super initWithShader:shader];
    if (self) {
        _camera = [[TWGLCamera alloc] initWithShader:shader];
        _carNode = [[CarNode alloc] initWithShader:shader];
        _mushroom = [[RWTCube alloc] initWithShader:shader];
        [self.children addObject:_carNode];
        [self.children addObject:_camera];
        [self.children addObject:_mushroom];
        
        //        xCube = [[RWTMushroom alloc] initWithShader:shader];
        //        xCube.position = GLKVector3Make(20, 0, 0);
        //        [self.children addObject:xCube];
        //
        //        yCube = [[RWTMushroom alloc] initWithShader:shader];
        //        yCube.position = GLKVector3Make(0, 20, 0);
        //        [self.children addObject:yCube];
        //
        //        zCube = [[RWTMushroom alloc] initWithShader:shader];
        //        zCube.position = GLKVector3Make(0, 0, 20);
        //        [self.children addObject:zCube];

    }
    return self;
}

- (void)render {
    GLKMatrix4 viewMatrix = GLKMatrix4Multiply(self.carNode.modelMatrix, self.camera.modelMatrix);
    viewMatrix = GLKMatrix4Invert(viewMatrix, nil);
    [super renderWithParentModelViewMatrix:viewMatrix];
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
}

@end

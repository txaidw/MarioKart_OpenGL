//
//  GameScene.h
//  MarioKart
//
//  Created by Txai Wieser on 22/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLDefaultScene.h"
#import "CarNode.h"
#import "TWGLCamera.h"

@interface GameScene: TWGLDefaultScene

@property (strong, nonatomic) TWGLCamera *camera;
@property (strong, nonatomic) CarNode *carNode;

@end

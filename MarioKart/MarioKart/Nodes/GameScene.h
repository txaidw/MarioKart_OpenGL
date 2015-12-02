//
//  GameScene.h
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLScene.h"
#import "CarNode.h"

@interface GameScene : TWGLScene

@property (weak) CarNode *playerCar;

@property TWGLCamera *trackCamera;

- (void)renderHUD;

- (void)prepareForTrackCamera;
- (void)backFromTrackCamera;
@end

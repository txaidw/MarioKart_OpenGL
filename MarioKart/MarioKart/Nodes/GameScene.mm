//
//  GameScene.m
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "GameScene.h"

#import "Pista.h"
#import "CarNode.h"
#import "QmarkBox.h"

@interface GameScene ()

@property Pista *pista;
@property CarNode *testCar;

@end

@implementation GameScene

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pista = [[Pista alloc] init];
        [self addChild:_pista];
        
        _testCar = [[CarNode alloc] init];
        _testCar.playerController = self;
        [_testCar addChild:self.camera];
        [self addChild:_testCar];

        self.camera.positionY = 2.5;
        self.camera.positionZ = -3.5;
        
//        QmarkBox *m = [[QmarkBox alloc] init];
//        [_testCar addChild:m];
//        m.positionY = 2;
    }
    return self;
}
@end

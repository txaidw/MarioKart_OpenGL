//
//  CarNode.h
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLNode.h"
#import "TWGLScene.h"

#define CAR_CHARACTER NSString*
#define CAR_CHARACTER_MARIO @"Mario/mk_kart.obj"
#define CAR_CHARACTER_BOWSER @"Bowser/kk_kart.obj"
#define CAR_CHARACTER_LUIGI @"Luigi/luigi.obj"
#define CAR_CHARACTER_PEACH @"Peach/pkart.obj"

@interface CarNode : TWGLNode

@property (weak) TWGLScene *playerController;

@end

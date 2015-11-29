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

#define CAR_ITEM NSString*
#define CAR_ITEM_TURBO @"CAR_ITEM_TURBO"
#define CAR_ITEM_TRAP @"CAR_ITEM_TRAP"
#define CAR_ITEM_MISSILE @"CAR_ITEM_MISSILE"

@interface CarNode : TWGLNode

@property (weak) TWGLScene *playerController;
- (void)action;
@end
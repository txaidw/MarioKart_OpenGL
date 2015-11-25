//
//  CarNode.h
//  MarioKart
//
//  Created by Txai Wieser on 22/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLNode.h"
#import "RWTCube.h"

@interface CarNode: RWTCube

@property (nonatomic) CGFloat acceleration;
@property (nonatomic) CGFloat direction;

@end

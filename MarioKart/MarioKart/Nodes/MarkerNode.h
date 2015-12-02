//
//  Marker.h
//  MarioKart
//
//  Created by Txai Wieser on 30/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLNode.h"
#import "Trap.h"
#import "CarNode.h"
@interface MarkerNode : Trap


- (instancetype)initWithModelNamed:(NSString *)named;

@property float colorR;
@property float colorG;
@property float colorB;

@end

//
//  CarNode.h
//  MarioKart
//
//  Created by Txai Wieser on 22/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLNode.h"
#import "Mushroom.h"

@interface CarNode: TWGLNode

- (instancetype)initWithShader:(TWGLShadersReference *)shader;

@property (nonatomic) CGFloat acceleration;
@property (nonatomic) CGFloat direction;

@end

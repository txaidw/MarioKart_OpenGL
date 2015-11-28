//
//  Pista.m
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "Pista.h"

@implementation Pista

- (instancetype)init
{
    GLMmodel *aModel = glmReadOBJ((char *)"MarioKart/Models/Pista/raceway_mariokart.obj");
    self = [super initWithModel:aModel];
    if (self) {
        self.scale = 15;
    }
    return self;
}

@end

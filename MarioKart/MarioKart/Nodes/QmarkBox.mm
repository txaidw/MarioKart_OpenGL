//
//  qmarkBox.m
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "QmarkBox.h"

@implementation QmarkBox


- (instancetype)init
{
    GLMmodel *aModel = glmReadOBJ("MarioKart/Models/Caixa/qmark.obj");
    self = [super initWithModel:aModel];
    if (self) {
        self.scale = 0.5;
        self.hasPhysicsBody = TRUE;
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
    self.rotationY += 4 *dt;
}
@end

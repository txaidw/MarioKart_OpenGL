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
    GLMmodel *aModel = glmReadOBJ("MarioKart/Models/Mario/mk_kart.obj");
    self = [super initWithModel:aModel];
    if (self) {
        
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
    self.rotationY += 1 *dt;
}
@end

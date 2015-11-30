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
    GLMmodel *aModel = glmReadOBJ((char *)"MarioKart/Models/Caixa/qmark.obj");
    self = [super initWithModel:aModel];
    if (self) {
        self.scale = 0.5;
        self.hasPhysicsBody = TRUE;
        
        int num = rand()%3;
        switch (num) {
            case 0:
                self.item = CAR_ITEM_TURBO;
                break;
            case 1:
                self.item = CAR_ITEM_MISSILE;
                break;
            default:
                self.item = CAR_ITEM_TRAP;
                break;
        }
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
    self.rotationY += 4 *dt;
}
@end

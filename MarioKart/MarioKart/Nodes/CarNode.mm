    //
//  CarNode.m
//  MarioKart
//
//  Created by Txai Wieser on 27/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "CarNode.h"
#import "Trap.h"
#import "Missile.h"
@interface CarNode ()

@property CAR_ITEM itemNamed;

@end

@implementation CarNode {
    float TURBO_VELOCITY_MULTIPLIER;
    float TURBO_TIME;
    
    float MAX_VELOCITY;
    float MIN_VELOCITY;
    float MINMAX_ACCELERATION;
    float ACCELERATION_RATE;
    
    float currentAcceleration;
    float currentVelocity;
    
    
    float MAX_DIRECTION;
    float MAX_CONVERSION;
    float CONVERSION_RATE;
    
    float currentConversion;
    float currentDirection;
    BOOL turboActivated;
    float currentTurboTime;

}

- (instancetype)init {
    return [self initWithModelNamed:CAR_CHARACTER_BOWSER];
}

- (instancetype)initWithModelNamed:(CAR_CHARACTER)named {
    NSString *name = [@"MarioKart/Models/" stringByAppendingString:named];
    GLMmodel *aModel = glmReadOBJ((char *)name.UTF8String);
    self = [super initWithModel:aModel];
    if (self) {
        self.itemNamed = CAR_ITEM_TURBO;
        TURBO_VELOCITY_MULTIPLIER = 3;
        TURBO_TIME = 222;
        MAX_VELOCITY = 1;
        MIN_VELOCITY = -0.5;
        MINMAX_ACCELERATION = 0.01;
        ACCELERATION_RATE = 0.001;
        
        MAX_DIRECTION = 80;
        MAX_CONVERSION = 10;
        CONVERSION_RATE = 1;
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
    
    if (self.playerController) {
        
        if (self.playerController.pressedKey_left) {
            currentConversion += CONVERSION_RATE;
            if (currentConversion > MAX_CONVERSION) {
                currentConversion = MAX_CONVERSION;
            }
        } else if (self.playerController.pressedKey_right) {
            currentConversion -= CONVERSION_RATE;
            if (currentConversion < -MAX_CONVERSION) {
                currentConversion = -MAX_CONVERSION;
            }
        } else {
            if (ABS(currentDirection) > CONVERSION_RATE*5) {
                currentConversion = -(currentDirection/ABS(currentDirection))*CONVERSION_RATE*4;
            } else {
                currentConversion = 0;
                currentDirection = 0;
            }
        }
        currentDirection += currentConversion;
        if (currentDirection > MAX_CONVERSION) {
            currentDirection = MAX_CONVERSION;
        } else if (currentDirection < -MAX_CONVERSION) {
            currentDirection = -MAX_CONVERSION;
        }
        
        if (self.playerController.pressedKey_forward) {
            currentAcceleration += ACCELERATION_RATE;
            if (currentAcceleration > MINMAX_ACCELERATION) {
                currentAcceleration = MINMAX_ACCELERATION;
            }
        } else if (self.playerController.pressedKey_backwards) {
            currentAcceleration -= ACCELERATION_RATE;
            if (currentAcceleration < -MINMAX_ACCELERATION) {
                currentAcceleration = -MINMAX_ACCELERATION;
            }
        } else {
            if (ABS(currentVelocity) > ACCELERATION_RATE*11) {
                currentAcceleration = -(currentVelocity/ABS(currentVelocity))*ACCELERATION_RATE*10;
            } else {
                currentAcceleration = 0;
                currentVelocity = 0;
            }
        }
        currentVelocity += currentAcceleration;
        if (currentVelocity > MAX_VELOCITY) {
            currentVelocity = MAX_VELOCITY;
        } else if (currentVelocity < MIN_VELOCITY) {
            currentVelocity = MIN_VELOCITY;
        }
        
        if (turboActivated) {
            currentVelocity = MAX_VELOCITY*TURBO_VELOCITY_MULTIPLIER;
            currentTurboTime += dt;
            if (currentTurboTime >= TURBO_TIME) {
                turboActivated = FALSE;
                printf("TURBO DESACTIVATED\n");
            }
        }
        self.rotationY += currentDirection*currentVelocity;
        self.positionX += currentVelocity * sin(self.rotationY*M_PI/180);
        self.positionZ += currentVelocity * cos(self.rotationY*M_PI/180);
        
    }
}

- (void)action {
    if (self.itemNamed) {
        if ([self.itemNamed isEqualToString:CAR_ITEM_TURBO]) {
            [self activateTurbo];
        } else if ([self.itemNamed isEqualToString:CAR_ITEM_TRAP]) {
            [self dropTrap];
        } else if ([self.itemNamed isEqualToString:CAR_ITEM_MISSILE]) {
            [self shootMissile];
        } else {
            printf("EMPTY SLOT\n");
        }
//        self.itemNamed = NULL;
    }
}

- (void)activateTurbo {
    printf("TURBO ACTIVATED\n");
    turboActivated = TRUE;
    currentTurboTime = 0;
}

- (void)dropTrap {
    printf("DROP TRAP\n");
    Trap *trap = [[Trap alloc] init];
    float xx, yy, zz;
    [self calculateAbsolutePosition:&xx yy:&yy zz:&zz];
    trap.positionX = xx;
    trap.positionY = yy;
    trap.positionZ = zz;
    
    float rx, ry, rz;
    [self calculateAbsoluteRotation:&rx yy:&ry zz:&rz];
    trap.rotationX = rx;
    trap.rotationY = ry;
    trap.rotationZ = rz;
    
    [self.scene addChild:trap];
    
}

- (void)shootMissile {
    printf("SHOOT MISSILE\n");
    Missile *missile = [[Missile alloc] init];
    float xx, yy, zz;
    [self calculateAbsolutePosition:&xx yy:&yy zz:&zz];
    missile.positionX = xx;
    missile.positionY = yy;
    missile.positionZ = zz;
    
    float rx, ry, rz;
    [self calculateAbsoluteRotation:&rx yy:&ry zz:&rz];
    missile.rotationX = rx;
    missile.rotationY = ry;
    missile.rotationZ = rz;
    
    [self.scene addChild:missile];
}
@end

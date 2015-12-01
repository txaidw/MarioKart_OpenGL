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
#import "MarkerNode.h"
#import "QmarkBox.h"

#define P1x 375.0
#define P1z 375.0

#define P2x -375.0
#define P2z 375.0

#define P3x -375.0
#define P3z -375.0

#define P4x 375.0
#define P4z -375.0

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

    
    int nextCheckpoint;
    
    BOOL conversion;
    
    float checkpoints[8];
    
    BOOL automaticAI;
}

- (instancetype)init {
    return [self initWithModelNamed:CAR_CHARACTER_BOWSER];
}

- (instancetype)initWithModelNamed:(CAR_CHARACTER)named {
    NSString *name = [@"MarioKart/Models/" stringByAppendingString:named];
    GLMmodel *aModel = glmReadOBJ((char *)name.UTF8String);
    self = [super initWithModel:aModel];
    if (self) {
        self.itemNamed = NULL;
        TURBO_VELOCITY_MULTIPLIER = 3;
        TURBO_TIME = 222;
        MAX_VELOCITY = 1;
        MIN_VELOCITY = -0.5;
        MINMAX_ACCELERATION = 0.01;
        ACCELERATION_RATE = 0.001;
        
        MAX_DIRECTION = 60;
        MAX_CONVERSION = 8;
        CONVERSION_RATE = 2;
        
        self.hasPhysicsBody = TRUE;

        self.frontCamera = [[TWGLCamera alloc] init];
        [self addChild:self.frontCamera];
        self.backCamera = [[TWGLCamera alloc] init];
        [self addChild:self.backCamera];
        self.backCamera.rotationY = 180;
        self.backCamera.positionZ = -1.2;
        
        
        self.markerNode = [[MarkerNode alloc] init];
        
        
        checkpoints[0] = P1x;
        checkpoints[1] = P1z;
        checkpoints[2] = P2x;
        checkpoints[3] = P2z;
        checkpoints[4] = P3x;
        checkpoints[5] = P3z;
        checkpoints[6] = P4x;
        checkpoints[7] = P4z;
        
        nextCheckpoint = 0;
        
        automaticAI = TRUE;
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
        self.rotationY += currentDirection*(0.1+currentVelocity/5);
        self.positionX += currentVelocity * sin(self.rotationY*M_PI/180.0);
        self.positionZ += currentVelocity * cos(self.rotationY*M_PI/180.0);
    } else if (automaticAI) {
        currentAcceleration += ACCELERATION_RATE;
        if (currentAcceleration > MINMAX_ACCELERATION) {
            currentAcceleration = MINMAX_ACCELERATION;
        }
        currentVelocity += currentAcceleration;
        if (currentVelocity > MAX_VELOCITY) {
            currentVelocity = MAX_VELOCITY;
        } else if (currentVelocity < MIN_VELOCITY) {
            currentVelocity = MIN_VELOCITY;
        }
        
        self.rotationY += currentDirection*(0.1+currentVelocity/5);
        self.positionX += currentVelocity * sin(self.rotationY*M_PI/180.0);
        self.positionZ += currentVelocity * cos(self.rotationY*M_PI/180.0);
        
   
        if (conversion) {
            self.rotationY -= 90;
            nextCheckpoint++;
            if (nextCheckpoint >= 4) {
                nextCheckpoint = 0;
            }
            conversion = FALSE;
        } else {
            float distanceToNextPoint = [self distanceToPointX:checkpoints[2*nextCheckpoint] y:self.positionY z:checkpoints[2*nextCheckpoint+1]];
            if (distanceToNextPoint < 5) {
                conversion = TRUE;
            }
            
        }
    }
    [self checkTrackBoundaries];

}

- (void)didCollideWith:(TWGLNode *)node {
    [super didCollideWith:node];
    
    
    if ([node isKindOfClass:[QmarkBox class]]) {
        self.itemNamed = ((QmarkBox *)node).item;
        [node removeFromParent];
    } else if ([node isKindOfClass:[Trap class]]) {
        currentAcceleration = 0;
        currentVelocity = 0;
        currentConversion = 0;
        currentDirection = 0;
        currentTurboTime = 9999;
        [node removeFromParent];
    } else if ([node isKindOfClass:[Missile class]]) {
        currentAcceleration = 0;
        currentVelocity = 0;
        currentConversion = 0;
        currentDirection = 0;
        currentTurboTime = 9999;
        [node removeFromParent];
    } else if ([node isKindOfClass:[CarNode class]]) {
        
//        
//        self.positionX += 10;
//        self.positionZ += 10;
    }
}

- (void)checkTrackBoundaries {
    float xx, yy, zz;
    [self calculateAbsolutePosition:&xx yy:&yy zz:&zz];
    
    float insideWall = 361;
    float outsideWall = 389;
    if ((xx < insideWall && xx > -insideWall) &&
        (zz < insideWall && zz > -insideWall)) {
        currentAcceleration = 0;
        currentVelocity = 0;
        currentConversion = 0;
        currentDirection = 0;
        currentTurboTime = 9999;
    } else if ((xx > outsideWall || xx < -outsideWall) ||
               (zz > outsideWall || zz < -outsideWall)) {
        currentAcceleration = 0;
        currentVelocity = 0;
        currentConversion = 0;
        currentDirection = 0;
        currentTurboTime = 9999;
    }

    
}

- (void)fireAction {
    if (self.itemNamed) {
        if ([self.itemNamed isEqualToString:CAR_ITEM_TURBO]) {
            [self activateTurbo];
        } else if ([self.itemNamed isEqualToString:CAR_ITEM_TRAP]) {
            [self dropTrap];
        } else if ([self.itemNamed isEqualToString:CAR_ITEM_MISSILE]) {
            [self shootMissile];
        } else {
            printf("WRONG ITEM\n");
        }
        self.itemNamed = NULL;
    } else {
        printf("EMPTY SLOT\n");
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
    
    trap.positionZ -= 3;
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

//
//  TWGLOBJLoader.h
//  OBJLoader
//
//  Created by Txai Wieser on 09/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "glm.h"
#import "TWGLVertex.h"

@interface TWGLOBJLoader : NSObject

+ (GLMmodel *)loadOBJ:(NSString *)named;
+ (GLfloat *)parseGLMmodel:(GLMmodel *)model;
@end

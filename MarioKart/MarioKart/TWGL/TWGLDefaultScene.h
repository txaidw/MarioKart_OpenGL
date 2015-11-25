//
//  RWTGameScene.h
//  HelloOpenGL
//
//  Created by Main Account on 3/24/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "TWGLNode.h"

@interface TWGLDefaultScene : TWGLNode

- (instancetype)initWithShader:(TWGLShadersReference *)shader;
- (void)render;
@end

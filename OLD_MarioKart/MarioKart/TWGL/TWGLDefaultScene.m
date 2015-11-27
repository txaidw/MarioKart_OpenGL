//
//  RWTGameScene.m
//  HelloOpenGL
//
//  Created by Main Account on 3/24/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "TWGLDefaultScene.h"

@implementation TWGLDefaultScene

- (instancetype)initWithShader:(TWGLShadersReference *)shader {

  if (self = [super initWithName:"TWGLDefaultScene" shader:shader]) {
  
  }
  return self;
}

- (void)render {
    GLKMatrix4 viewMatrix = GLKMatrix4Identity;
    [super renderWithParentModelViewMatrix:viewMatrix];
}
@end

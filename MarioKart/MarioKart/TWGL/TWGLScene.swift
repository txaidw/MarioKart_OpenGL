//
//  TWGLGenericScene.swift
//  MarioKart
//
//  Created by Txai Wieser on 11/3/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import UIKit

class TWGLScene: TWGLNode {
    let mushroom:TWGLNode
    
    init(shader: TWGLShaderReference) {
        super.init(name: "TWGLScene", texture: nil, shader: shader, vertices: nil)
        
        shader = mushroom
    }
    
    - (instancetype)initWithShader:(RWTBaseEffect *)shader {
    if ((self = [super initWithName:"RWTestScene" shader:shader vertices:nil vertexCount:0])) {
    
    _mushroom = [[RWTMushroom alloc] initWithShader:shader];
    [self.children addObject:_mushroom];
    
    self.position = GLKVector3Make(0, -1, -5);
    
    }
    return self;
    }
    
    @end

    
}
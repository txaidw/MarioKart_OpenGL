//
//  TWGLVertexInfo.swift
//  MarioKart
//
//  Created by Txai Wieser on 11/3/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

enum TWGLVertexAttrib:Int {
    case Position = 0
    case Color = 1
    case TexCoord = 2
    case Normal = 3
}

struct TWGLVertexInfo {
    let position:(x:GLfloat, y:GLfloat, z:GLfloat)
    let color:(r:GLfloat, g:GLfloat, b:GLfloat, a:GLfloat)
    let texCoord:(u:GLfloat, v:GLfloat)
    let normal:(x:GLfloat, y:GLfloat, z:GLfloat)
    
    init(_ all:(GLfloat, GLfloat, GLfloat, GLfloat, GLfloat, GLfloat, GLfloat, GLfloat, GLfloat, GLfloat, GLfloat, GLfloat)) {
        position = (all.0, all.1, all.2)
        color = (all.3, all.4, all.5, all.6)
        texCoord = (all.7, all.8)
        normal = (all.9, all.10, all.11)
    }
    
    init(_ all:(GLfloat, GLfloat, GLfloat)) {
        position = (all.0, all.1, all.2)
        color = (1.0, 0.0, 0.0, 1.0)
        texCoord = (1.0, 1.0)
        normal = (0.0, 0.0, 1.0)
    }
}
//
//  TWGLVertexInfo.swift
//  MarioKart
//
//  Created by Txai Wieser on 11/3/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

struct TWGLVertexInfo {
    let position:(x:GLfloat, y:GLfloat, z:GLfloat)
    let color:(r:GLfloat, g:GLfloat, b:GLfloat, a:GLfloat)
    let texCoord:(u:GLfloat, v:GLfloat)
    let normal:(x:GLfloat, y:GLfloat, z:GLfloat)
}
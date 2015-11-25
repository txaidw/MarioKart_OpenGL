//
//  TWGLVertexInfo.swift
//  MarioKart
//
//  Created by Txai Wieser on 11/3/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

enum TWGLVertexAttrib:GLuint {
    case Position = 0
    case TexCoord = 1
    case Normal = 2
    case Diffuse = 3
    case Specular = 4
    case Color = 5
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
    
    init(_ p:(GLfloat, GLfloat, GLfloat)) {
        position = (p.0, p.1, p.2)
        color = (1.0, 0.0, 0.0, 1.0)
        texCoord = (1.0, 1.0)
        normal = (0.0, 0.0, 1.0)
    }
    
//    static func objectData(unsafeModel:UnsafeMutablePointer<GLMmodel>) -> [TWGLVertexInfo] {
//        let model = unsafeModel.memory
//        var data = [TWGLVertexInfo]()
//        for i in 0.stride(to: Int(model.numvertices), by: 3) {
//            data.append(TWGLVertexInfo((model.vertices[i], model.vertices[i+1], model.vertices[i+2])))
//        }
//        return data
//    }
}
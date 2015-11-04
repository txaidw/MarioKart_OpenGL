//
//  TWGLGenericScene.swift
//  MarioKart
//
//  Created by Txai Wieser on 11/3/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

class TWGLScene:TWGLNode {
    let mushroom:TWGLNode
    let cube:TWGLNode
    init(shader: TWGLShaderReference) {
        mushroom = MushroomNode(shader: shader)
        mushroom.position = GLKVector3Make(mushroom.position.x, mushroom.position.y-2, mushroom.position.z)
        cube = CubeNode(shader: shader)
        cube.position = GLKVector3Make(cube.position.x, cube.position.y+2, cube.position.z)
        super.init(name: "TWGLScene", texture: nil, shader: shader, vertices: [TWGLVertexInfo]())
        children.append(mushroom)
        children.append(cube)
    }
}
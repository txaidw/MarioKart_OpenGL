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
    var camera:TWGLNode!
    init(shader: TWGLShaderReference) {
        camera = CameraNode(shader: shader)
        camera.position.y = -2
        
        super.init(name: "TWGLScene", texture: nil, shader: shader, vertices: [TWGLVertexInfo]())
//        children.append(camera)
    }
    
    
//    func render() {
//        let viewMatrix = carnode.modelMatrix()
//        render(viewMatrix)
//    }
}
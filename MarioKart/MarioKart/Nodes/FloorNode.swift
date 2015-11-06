//
//  FloorNode.swift
//  MarioKart
//
//  Created by Txai Wieser on 05/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

class FloorNode: TWGLNode {

    init(shader: TWGLShaderReference) {
        super.init(name: "floor", texture: nil, shader: shader, vertices: floor_vertices)
        matColor = (0.0, 0.0, 1.0, 1.0)
    }
    
    let floor_vertices: [TWGLVertexInfo] = {
        let d_size:Float = 100
        return [
            TWGLVertexInfo((1.0 * d_size, 0.0 * d_size, 1.0 * d_size)),
            TWGLVertexInfo((1.0 * d_size, 0.0 * d_size, -1.0 * d_size)),
            TWGLVertexInfo((-1.0 * d_size, 0.0 * d_size, -1.0 * d_size)),
            
            TWGLVertexInfo((-1.0 * d_size, 0.0 * d_size, -1.0 * d_size)),
            TWGLVertexInfo((-1.0 * d_size, 0.0 * d_size, 1.0 * d_size)),
            TWGLVertexInfo((1.0 * d_size, 0.0 * d_size, 1.0 * d_size))
        ]
    }()
}

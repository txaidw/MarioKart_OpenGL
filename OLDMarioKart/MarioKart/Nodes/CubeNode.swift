//
//  CubeNode.swift
//  MarioKart
//
//  Created by Txai Wieser on 03/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

class CubeNode: TWGLNode {
    
    
    var vertices:[TWGLVertexInfo] = [
    // Front
    TWGLVertexInfo((1, -1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1)), // 0
    TWGLVertexInfo((1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1)), // 1
    TWGLVertexInfo((-1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1)), // 2
    
    TWGLVertexInfo((-1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1)), // 2
    TWGLVertexInfo((-1, -1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1)), // 3
    TWGLVertexInfo((1, -1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1)), // 0
    
    // Back
    TWGLVertexInfo((-1, -1, -1, 0, 0, 1, 1, 1, 0, 0, 0, -1)), // 4
    TWGLVertexInfo((-1, 1, -1, 0, 1, 0, 1, 1, 1, 0, 0, -1)), // 5
    TWGLVertexInfo((1, 1, -1, 1, 0, 0, 1, 0, 1, 0, 0, -1)), // 6
    
    TWGLVertexInfo((1, 1, -1, 1, 0, 0, 1, 0, 1, 0, 0, -1)), // 6
    TWGLVertexInfo((1, -1, -1, 0, 0, 0, 1, 0, 0, 0, 0, -1)), // 7
    TWGLVertexInfo((-1, -1, -1, 0, 0, 1, 1, 1, 0, 0, 0, -1)), // 4
    
    // Left
    TWGLVertexInfo((-1, -1, 1, 1, 0, 0, 1, 1, 0, -1, 0, 0)), // 8
    TWGLVertexInfo((-1, 1, 1, 0, 1, 0, 1, 1, 1, -1, 0, 0)), // 9
    TWGLVertexInfo((-1, 1, -1, 0, 0, 1, 1, 0, 1, -1, 0, 0)), // 10
    
    TWGLVertexInfo((-1, 1, -1, 0, 0, 1, 1, 0, 1, -1, 0, 0)), // 10
    TWGLVertexInfo((-1, -1, -1, 0, 0, 0, 1, 0, 0, -1, 0, 0)), // 11
    TWGLVertexInfo((-1, -1, 1, 1, 0, 0, 1, 1, 0, -1, 0, 0)), // 8
    
    // Right
    TWGLVertexInfo((1, -1, -1, 1, 0, 0, 1, 1, 0, 1, 0, 0)), // 12
    TWGLVertexInfo((1, 1, -1, 0, 1, 0, 1, 1, 1, 1, 0, 0)), // 13
    TWGLVertexInfo((1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0)), // 14
    
    TWGLVertexInfo((1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0)), // 14
    TWGLVertexInfo((1, -1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0)), // 15
    TWGLVertexInfo((1, -1, -1, 1, 0, 0, 1, 1, 0, 1, 0, 0)), // 12
    
    // Top
    TWGLVertexInfo((1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0)), // 16
    TWGLVertexInfo((1, 1, -1, 0, 1, 0, 1, 1, 1, 0, 1, 0)), // 17
    TWGLVertexInfo((-1, 1, -1, 0, 0, 1, 1, 0, 1, 0, 1, 0)), // 18
    
    TWGLVertexInfo((-1, 1, -1, 0, 0, 1, 1, 0, 1, 0, 1, 0)), // 18
    TWGLVertexInfo((-1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0)), // 19
    TWGLVertexInfo((1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0)), // 16
    
    // Bottom
    TWGLVertexInfo((1, -1, -1, 1, 0, 0, 1, 1, 0, 0, -1, 0)), // 20
    TWGLVertexInfo((1, -1, 1, 0, 1, 0, 1, 1, 1, 0, -1, 0)), // 21
    TWGLVertexInfo((-1, -1, 1, 0, 0, 1, 1, 0, 1, 0, -1, 0)), // 22
    
    TWGLVertexInfo((-1, -1, 1, 0, 0, 1, 1, 0, 1, 0, -1, 0)), // 22
    TWGLVertexInfo((-1, -1, -1, 0, 0, 0, 1, 0, 0, 0, -1, 0)), // 23
    TWGLVertexInfo((1, -1, -1, 1, 0, 0, 1, 1, 0, 0, -1, 0))] // 20
    
        
    init(shader:TWGLShaderReference) {
        super.init(name: "cube", texture: "dungeon_01.png", shader: shader, vertices: vertices)
    }
    
    
    override func update(delta: NSTimeInterval) {
        rotation.y = rotation.y + Float(M_PI/8 * delta)
    }
}

//
//  CameraNode.swift
//  MarioKart
//
//  Created by Txai Wieser on 06/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

class CameraNode: TWGLNode {
    init(shader:TWGLShaderReference) {
        super.init(name: "camera_node", texture: nil, shader: shader, vertices: nil)
    }
}
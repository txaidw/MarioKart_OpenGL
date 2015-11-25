//
//  GameScene.swift
//  MarioKart
//
//  Created by Txai Wieser on 05/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

class GameScene: TWGLScene {
    var floor:TWGLNode!
    
    var xCube:TWGLNode!
    var yCube:TWGLNode!
    var zCube:TWGLNode!

    var mushroom:TWGLNode!
    var carNode:CarNode!
    
    override init(shader: TWGLShaderReference) {
        super.init(shader: shader)

//        floor = FloorNode(shader: shader)
//        children.append(floor)

        xCube = CubeNode(shader: shader)
        xCube.matColor = (1.0, 0.0, 0.0, 1.0)
        xCube.position.x = 20
        children.append(xCube)

        yCube = CubeNode(shader: shader)
        yCube.matColor = (0.0, 1.0, 0.0, 1.0)
        yCube.position.y = 20
        children.append(yCube)
        
        zCube = CubeNode(shader: shader)
        zCube.matColor = (0.0, 0.0, 1.0, 1.0)
        zCube.position.z = 20
        children.append(zCube)

        mushroom = MushroomNode(shader: shader)
        children.append(mushroom)
        
        carNode = CarNode(shader: shader)
        carNode.children.append(camera)
        camera.position.y = 5
        camera.rotation.x = -Float(M_PI)/6
        camera.position.z = 10
        children.append(carNode)
    }
    
    func render() {
        var viewMatrix = GLKMatrix4Multiply(carNode.modelMatrix(), camera.modelMatrix())
        viewMatrix = GLKMatrix4Invert(viewMatrix, nil)
        render(viewMatrix)
    }
}

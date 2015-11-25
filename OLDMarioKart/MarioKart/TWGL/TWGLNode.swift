//
//  TWGLNode.swift
//  MarioKart
//
//  Created by Txai Wieser on 11/3/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

class TWGLNode {
    let name:String
    var vao = GLuint()
    var vertexBuffer = GLuint()
    var indexBuffer = GLuint()

//    var vertexPointBuffer = GLuint()
//    var vertexUVBuffer = GLuint()
    var vertexCount:Int = 0
    weak var shader:TWGLShaderReference?
    
    var texture = GLuint()
    //    var size:GLKVector3 = 0
    
    
    var position:(x:Float, y:Float, z:Float) = (0, 0, 0)
    var rotation:(x:Float, y:Float, z:Float) = (0, 0, 0)
    var scale:Float = 1.0
    var matColor:(r:Float, g:Float, b:Float, a:Float) = (1, 1, 1, 1)
    var children:[TWGLNode] = []
    
    
    init(name:String, texture:String?, shader:TWGLShaderReference, vertices:[TWGLVertexInfo]?) {
        self.name = name
        self.shader = shader
        if let v = vertices {
            self.vertexCount = v.count
            
            glGenVertexArraysOES(1, &vao)
            glBindVertexArrayOES(vao)


            
            // Generate vertex buffer
            glGenBuffers(1, &vertexBuffer)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
            glBufferData(GLenum(GL_ARRAY_BUFFER), vertexCount * sizeof(TWGLVertexInfo), v, GLenum(GL_STATIC_DRAW))
            // Enable vertex attributes
            
            let positionSlotFirstComponent: UnsafePointer = UnsafePointer<Int>(bitPattern: 0)
            glEnableVertexAttribArray(0)
            glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(TWGLVertexInfo)), positionSlotFirstComponent)
            
            let colorSlotFirstComponent: UnsafePointer = UnsafePointer<Int>(bitPattern: sizeof(Float) * 3)
            glEnableVertexAttribArray(TWGLVertexAttrib.Color.rawValue)
            glVertexAttribPointer(TWGLVertexAttrib.Color.rawValue, 4, GLenum( GL_FLOAT), GLboolean(GLboolean(GL_FALSE)), GLsizei(sizeof(TWGLVertexInfo)), colorSlotFirstComponent)
            
            let texCoordSlotFirstComponent: UnsafePointer = UnsafePointer<Int>(bitPattern: sizeof(Float) * 7)
            glEnableVertexAttribArray(GLuint(TWGLVertexAttrib.TexCoord.rawValue))
            glVertexAttribPointer(GLuint(TWGLVertexAttrib.TexCoord.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(TWGLVertexInfo)), texCoordSlotFirstComponent)
            
            let normalSlotFirstComponent: UnsafePointer = UnsafePointer<Int>(bitPattern: sizeof(Float) * 9)
            glEnableVertexAttribArray(GLuint(TWGLVertexAttrib.Normal.rawValue))
            glVertexAttribPointer(GLuint(TWGLVertexAttrib.Normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(TWGLVertexInfo)), normalSlotFirstComponent)
            
            glBindVertexArrayOES(0)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
            
            if let t = texture {
                loadTexture(t)
            }
        }
    }
    
    
    func loadTexture(filename:String) {
        let path = NSBundle.mainBundle().pathForResource(filename, ofType: nil)
        
        
        let options = [GLKTextureLoaderOriginBottomLeft : true]
        
        do {
            let info = try GLKTextureLoader.textureWithContentsOfFile(path!, options: options)
            self.texture = info.name
        } catch let error as NSError {
            print("Error loading file: %@", error.localizedDescription)
        }
    }
    
    
    func modelMatrix() -> GLKMatrix4 {
        var modelMatrix = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, position.x, position.y, position.z)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.x, 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.y, 0, 1, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.z, 0, 0, 1)
        modelMatrix = GLKMatrix4Scale(modelMatrix, scale, scale, scale)
        return modelMatrix
    }
    
    var savedModelViewMatrix = GLKMatrix4Identity
    
    func render(parentModelViewMatrix:GLKMatrix4) {
        savedModelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, modelMatrix())
        children.forEach { $0.render(savedModelViewMatrix) }
        
        shader!.modelViewMatrix = savedModelViewMatrix
        shader!.texture = texture
        shader!.matColor = GLKVector4Make(matColor.r, matColor.g, matColor.b, matColor.a)
        shader!.prepareToDraw()
        
        glBindVertexArrayOES(vao)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, Int32(vertexCount))
        glBindVertexArrayOES(0)
    }
    
    func update(delta:NSTimeInterval) {
        children.forEach { $0.update(delta) }
    }
    
    
    //    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    }
    //    - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //    }
    //    - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    }
    
    //    - (CGRect)boundingBoxWithModelViewMatrix:(GLKMatrix4)parentModelViewMatrix {
    //
    //    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix])
    //
    //    GLKVector4 lowerLeft = GLKVector4Make(-self.width/2, -self.height/2, 0, 1)
    //    lowerLeft = GLKMatrix4MultiplyVector4(modelViewMatrix, lowerLeft)
    //    GLKVector4 upperRight = GLKVector4Make(self.width/2, self.height/2, 0, 1)
    //    upperRight = GLKMatrix4MultiplyVector4(modelViewMatrix, upperRight)
    //
    //    CGRect boundingBox = CGRectMake(lowerLeft.x, lowerLeft.y, upperRight.x - lowerLeft.x, upperRight.y - lowerLeft.y)
    //    return boundingBox
    
}
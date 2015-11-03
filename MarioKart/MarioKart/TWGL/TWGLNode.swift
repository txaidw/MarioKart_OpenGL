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
    let vertexCount:Int
    weak var shader:TWGLShaderReference?
    
    var texture = GLuint()
    //    var size:GLKVector3 = 0
    
    
    var position:GLKVector3 = GLKVector3Make(0, 0, 0)
    var rotation:GLKVector3 = GLKVector3Make(0, 0, 0)
    var scale:GLfloat = 1.0
    var matColor:GLKVector4 = GLKVector4Make(1, 1, 1, 1)
    var children:[TWGLNode] = []
    
    
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
    
    
    init(name:String, texture:String?, shader:TWGLShaderReference, vertices:[TWGLVertexInfo]) {
        self.name = name
        self.shader = shader
        self.vertexCount = vertices.count
        
        glGenVertexArraysOES(1, &vao)
        glBindVertexArrayOES(vao)
        
        // Generate vertex buffer
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertexCount * sizeof(TWGLVertexInfo), vertices, GLenum(GL_STATIC_DRAW))
        
        // Enable vertex attributes
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE),  GLsizei(sizeof(TWGLVertexInfo)), BUFFER_OFFSET(0))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Color.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Color.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(TWGLVertexInfo)), BUFFER_OFFSET(3))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.TexCoord0.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.TexCoord0.rawValue), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(TWGLVertexInfo)), BUFFER_OFFSET((3+4)))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Normal.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Normal.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(sizeof(TWGLVertexInfo)), BUFFER_OFFSET((3+4+3)))
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
        
        if let t = texture {
            loadTexture(t)
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
    
    func render(parentModelViewMatrix:GLKMatrix4) {
        let modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, modelMatrix())
        children.forEach { $0.render(modelViewMatrix) }
        
        shader?.modelViewMatrix = modelViewMatrix
        shader?.texture = self.texture
        shader?.matColor = self.matColor
        shader?.prepareToDraw()
        
        glBindVertexArrayOES(vao)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, Int32(vertexCount))
        glBindVertexArrayOES(0)
    }
    
    func update(delta:NSTimeInterval) {
        children.forEach { $0.update(delta) }
    }
    //
    //
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
//
//  TWGLShaderReference.swift
//  MarioKart
//
//  Created by Txai Wieser on 11/3/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

class TWGLShaderReference {
    
    var programHandle = GLuint()
    var modelViewMatrix = GLKMatrix4Identity
    var projectionMatrix = GLKMatrix4Identity
    var texture = GLuint()
    var matColor = GLKVector4Make(1, 1, 1, 1)
    
    var modelViewMatrixUniform = GLint()
    var projectionMatrixUniform = GLint()
    var texUniform = GLint()
    var lightColorUniform = GLint()
    var lightAmbientIntensityUniform = GLint()
    var lightDiffuseIntensityUniform = GLint()
    var lightDirectionUniform = GLint()
    var matSpecularIntensityUniform = GLint()
    var shininessUniform = GLint()
    var matColorUniform = GLint()
    
    
    func compileShader(type: GLenum, file: String) -> GLuint {
        var status: GLint = 0
        var source: UnsafePointer<Int8>
        do {
            source = try NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding).UTF8String
        } catch {
            assertionFailure("Failed to load vertex shader")
            return 0
        }
        var castSource = UnsafePointer<GLchar>(source)
        
        var shader = GLuint()
        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader)
        
        //#if defined(DEBUG)
        //        var logLength: GLint = 0
        //        glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        //        if logLength > 0 {
        //            var log = UnsafeMutablePointer<GLchar>(malloc(Int(logLength)))
        //            glGetShaderInfoLog(shader, logLength, &logLength, log)
        //            NSLog("Shader compile log: \n%s", log)
        //            free(log)
        //        }
        //#endif
        
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &status)
        if status == 0 {
            glDeleteShader(shader)
            assertionFailure("Failed to load shader")
        }
        return shader
    }
    
    init(vertexShader:String, fragmentShader:String) {
        let vertexShaderName = compileShader(GLenum(GL_VERTEX_SHADER), file: NSBundle.mainBundle().pathForResource(vertexShader, ofType: nil)!)
        let fragmentShaderName = compileShader(GLenum(GL_FRAGMENT_SHADER), file: NSBundle.mainBundle().pathForResource(fragmentShader, ofType: nil)!)
        
        programHandle = glCreateProgram()
        glAttachShader(programHandle, vertexShaderName)
        glAttachShader(programHandle, fragmentShaderName)
        
        glBindAttribLocation(programHandle, GLuint(TWGLVertexAttrib.Position.rawValue), "a_Position")
        glBindAttribLocation(programHandle, GLuint(TWGLVertexAttrib.Color.rawValue), "a_Color")
        glBindAttribLocation(programHandle, GLuint(TWGLVertexAttrib.TexCoord.rawValue), "a_TexCoord")
        glBindAttribLocation(programHandle, GLuint(TWGLVertexAttrib.Normal.rawValue), "a_Normal")
        
        glLinkProgram(programHandle)
        
        modelViewMatrixUniform = glGetUniformLocation(programHandle, "u_ModelViewMatrix")
        projectionMatrixUniform = glGetUniformLocation(programHandle, "u_ProjectionMatrix")
        texUniform = glGetUniformLocation(programHandle, "u_Texture")
        lightColorUniform = glGetUniformLocation(programHandle, "u_Light.Color")
        lightAmbientIntensityUniform = glGetUniformLocation(programHandle, "u_Light.AmbientIntensity")
        lightDiffuseIntensityUniform = glGetUniformLocation(programHandle, "u_Light.DiffuseIntensity")
        lightDirectionUniform = glGetUniformLocation(programHandle, "u_Light.Direction")
        matSpecularIntensityUniform = glGetUniformLocation(programHandle, "u_MatSpecularIntensity")
        shininessUniform = glGetUniformLocation(programHandle, "u_Shininess")
        matColorUniform = glGetUniformLocation(programHandle, "u_MatColor")
                
        //#if defined(DEBUG)
        //        var logLength: GLint = 0
        //        glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
        //        if logLength > 0 {
        //            var log = UnsafeMutablePointer<GLchar>(malloc(Int(logLength)))
        //            glGetShaderInfoLog(shader, logLength, &logLength, log)
        //            NSLog("Shader compile log: \n%s", log)
        //            free(log)
        //        }
        //#endif
        var status = GLint()
        glGetProgramiv(programHandle, GLenum(GL_LINK_STATUS), &status)
        if status == 0 {
            assertionFailure("Failed linking shader program")
        }
    }
    
    
    func prepareToDraw() {
        glUseProgram(programHandle)
        
        withUnsafePointer(&modelViewMatrix, {
            glUniformMatrix4fv(modelViewMatrixUniform, 1, 0, UnsafePointer($0))
        })
        
        withUnsafePointer(&projectionMatrix, {
            glUniformMatrix4fv(projectionMatrixUniform, 1, 0, UnsafePointer($0))
        })
        
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), texture)
        glUniform1i(texUniform, 1)
        
        glUniform3f(lightColorUniform, 1, 1, 1)
        glUniform1f(lightAmbientIntensityUniform, 0.1)
        let lightDirection = GLKVector3Normalize(GLKVector3Make(0, 1, -1))
        glUniform3f(lightDirectionUniform, lightDirection.x, lightDirection.y, lightDirection.z)
        glUniform1f(lightDiffuseIntensityUniform, 0.7)
        glUniform1f(matSpecularIntensityUniform, 2.0)
        glUniform1f(shininessUniform, 8.0)
        glUniform4f(matColorUniform, matColor.r, matColor.g, matColor.b, matColor.a)
    }
}
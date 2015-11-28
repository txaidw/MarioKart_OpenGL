//
//  RWTModel.m
//  HelloOpenGL
//
//  Created by Main Account on 3/18/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "TWGLNode.h"
#import "TWGLShadersReference.h"
#import <OpenGLES/ES2/glext.h>
#import "TWGLOBJLoader.h"

@implementation TWGLNode {
    char *_name;
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    unsigned int _vertexCount;
    unsigned int _indexCount;
    TWGLShadersReference *_shader;
//    GLMmodel *model;
}

- (instancetype)initWithName:(char *)name shader:(TWGLShadersReference *)shader
{
    self = [self initWithName:name shader:shader vertices:NULL vertexCount:0 inidices:NULL indexCount:0];
    if (self) {
    }
    return self;
}

- (instancetype)initWithName:(char *)name shader:(TWGLShadersReference *)shader modelNamed:(NSString *)modelNamed {
    if (self = [super init]) {
//        model = [TWGLOBJLoader loadOBJ:modelNamed];
        _name = name;
        _shader = shader;
        self.position = GLKVector3Make(0, 0, 0);
        self.rotationX = 0;
        self.rotationY = 0;
        self.rotationZ = 0;
        self.scale = 1.0;
        self.children = [NSMutableArray array];
//        glmCreateArrays(model, GLM_NONE);

//        glGenVertexArraysOES(1, &_vao);
//        glBindVertexArrayOES(_vao);
//        
//        // Generate vertex buffer
//        
//        glGenBuffers(1, &_vertexBuffer);
//        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
//        glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(GLfloat), vertices, GL_STATIC_DRAW);
//        
//        // Generate index buffer
//        glGenBuffers(1, &_indexBuffer);
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(GLubyte), indices, GL_STATIC_DRAW);
//        
//        // Enable vertex attributes
//        glEnableVertexAttribArray(TWGLVertexAttribPosition);
//        glVertexAttribPointer(TWGLVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), 0);
        //        glEnableVertexAttribArray(TWGLVertexAttribColor);
        //        glVertexAttribPointer(TWGLVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(TWGLVertex), (const GLvoid *) offsetof(TWGLVertex, Color));
        //        glEnableVertexAttribArray(TWGLVertexAttribTexCoord);
        //        glVertexAttribPointer(TWGLVertexAttribTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(TWGLVertex), (const GLvoid *) offsetof(TWGLVertex, TexCoord));
        //        glEnableVertexAttribArray(TWGLVertexAttribNormal);
        //        glVertexAttribPointer(TWGLVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(TWGLVertex), (const GLvoid *) offsetof(TWGLVertex, Normal));
        
//        glBindVertexArrayOES(0);
//        glBindBuffer(GL_ARRAY_BUFFER, 0);
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
    }
    return self;
}

- (instancetype)initWithName:(char *)name shader:(TWGLShadersReference *)shader vertices:(GLfloat *)vertices vertexCount:(unsigned int)vertexCount inidices:(GLubyte *)indices indexCount:(unsigned int)indexCount {
    
    if (self = [super init]) {
        
        _name = name;
        _vertexCount = vertexCount;
        _indexCount = indexCount;
        _shader = shader;
        self.position = GLKVector3Make(0, 0, 0);
        self.rotationX = 0;
        self.rotationY = 0;
        self.rotationZ = 0;
        self.scale = 1.0;
        self.children = [NSMutableArray array];
        
        glGenVertexArraysOES(1, &_vao);
        glBindVertexArrayOES(_vao);
        
        // Generate vertex buffer

        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(GLfloat), vertices, GL_STATIC_DRAW);
        
        // Generate index buffer
        glGenBuffers(1, &_indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(GLubyte), indices, GL_STATIC_DRAW);
        
        // Enable vertex attributes
        glEnableVertexAttribArray(TWGLVertexAttribPosition);
        glVertexAttribPointer(TWGLVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), 0);
//        glEnableVertexAttribArray(TWGLVertexAttribColor);
//        glVertexAttribPointer(TWGLVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(TWGLVertex), (const GLvoid *) offsetof(TWGLVertex, Color));
//        glEnableVertexAttribArray(TWGLVertexAttribTexCoord);
//        glVertexAttribPointer(TWGLVertexAttribTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(TWGLVertex), (const GLvoid *) offsetof(TWGLVertex, TexCoord));
//        glEnableVertexAttribArray(TWGLVertexAttribNormal);
//        glVertexAttribPointer(TWGLVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(TWGLVertex), (const GLvoid *) offsetof(TWGLVertex, Normal));
        
        glBindVertexArrayOES(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
    }
    return self;
}

- (GLKMatrix4)modelMatrix {
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationX, 1, 0, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationY, 0, 1, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationZ, 0, 0, 1);
    modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale, self.scale, self.scale);
    return modelMatrix;
}

- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix {
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix]);
    for (TWGLNode *child in self.children) {
        [child renderWithParentModelViewMatrix:modelViewMatrix];
    }
    
    _shader.modelViewMatrix = modelViewMatrix;
    _shader.texture = self.texture;
    [_shader prepareToDraw];
    

//    if (model) {
//        glmDrawArrays(model, 0);
//    } else {
        glBindVertexArrayOES(_vao);
        glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_BYTE, 0);
        glBindVertexArrayOES(0);
//    }
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    for (TWGLNode *child in self.children) {
        [child updateWithDelta:dt];
    }
}

- (void)loadTexture:(NSString *)filename {
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    
    NSDictionary *options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if (info == nil) {
        NSLog(@"Error loading file: %@", error.localizedDescription);
    } else {
        self.texture = info.name;
    }
}

@end

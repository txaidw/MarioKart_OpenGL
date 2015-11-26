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

@implementation TWGLNode {
    char *_name;
    GLuint _vao;
    GLuint _vertexBuffer;
    unsigned int _vertexCount;
    TWGLShadersReference *_shader;
}

- (instancetype)initWithName:(char *)name shader:(TWGLShadersReference *)shader vertices:(GLfloat *)vertices vertexCount:(unsigned int)vertexCount {
    
    if (self = [super init]) {
        
        _name = name;
        _vertexCount = vertexCount;
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
        glBufferData(GL_ARRAY_BUFFER, vertexCount * 3 * sizeof(GL_FLOAT), vertices, GL_STATIC_DRAW);
//        glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(GL_FLOAT), vertices, GL_STATIC_DRAW);
        
//        // Generate index buffer
//        glGenBuffers(1, &_indexBuffer);
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(GLubyte), indices, GL_STATIC_DRAW);
        
        // Enable vertex attributes
        glEnableVertexAttribArray(TWGLVertexAttribPosition);
//        glVertexAttribPointer(TWGLVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT), (const GLvoid *) offsetof(TWGLVertex, Position));
        glVertexAttribPointer(TWGLVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GL_FLOAT), 0);
//        glVertexAttribPointer(TWGLVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT), 0);
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
    
    glBindVertexArrayOES(_vao);
    glDrawArrays(GL_TRIANGLES, 0, _vertexCount);
    glBindVertexArrayOES(0);
    
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

//
//  RWTCube.m
//  HelloOpenGL
//
//  Created by Main Account on 3/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "RWTCube.h"

//const TWGLVertex vertices[] = {
//    // Front
//    {{1, -1, 1}, {1, 0, 0, 1}, {1, 0}, {0, 0, 1}}, // 0
//    {{1, 1, 1}, {0, 1, 0, 1}, {1, 1}, {0, 0, 1}}, // 1
//    {{-1, 1, 1}, {0, 0, 1, 1}, {0, 1}, {0, 0, 1}}, // 2
//    {{-1, -1, 1}, {0, 0, 0, 1}, {0, 0}, {0, 0, 1}}, // 3
//    
//    // Back
//    {{-1, -1, -1}, {0, 0, 1, 1}, {1, 0}, {0, 0, -1}}, // 4
//    {{-1, 1, -1}, {0, 1, 0, 1}, {1, 1}, {0, 0, -1}}, // 5
//    {{1, 1, -1}, {1, 0, 0, 1}, {0, 1}, {0, 0, -1}}, // 6
//    {{1, -1, -1}, {0, 0, 0, 1}, {0, 0}, {0, 0, -1}}, // 7
//    
//    // Left
//    {{-1, -1, 1}, {1, 0, 0, 1}, {1, 0}, {-1, 0, 0}}, // 8
//    {{-1, 1, 1}, {0, 1, 0, 1}, {1, 1}, {-1, 0, 0}}, // 9
//    {{-1, 1, -1}, {0, 0, 1, 1}, {0, 1}, {-1, 0, 0}}, // 10
//    {{-1, -1, -1}, {0, 0, 0, 1}, {0, 0}, {-1, 0, 0}}, // 11
//    
//    // Right
//    {{1, -1, -1}, {1, 0, 0, 1}, {1, 0}, {1, 0, 0}}, // 12
//    {{1, 1, -1}, {0, 1, 0, 1}, {1, 1}, {1, 0, 0}}, // 13
//    {{1, 1, 1}, {0, 0, 1, 1}, {0, 1}, {1, 0, 0}}, // 14
//    {{1, -1, 1}, {0, 0, 0, 1}, {0, 0}, {1, 0, 0}}, // 15
//    
//    // Top
//    {{1, 1, 1}, {1, 0, 0, 1}, {1, 0}, {0, 1, 0}}, // 16
//    {{1, 1, -1}, {0, 1, 0, 1}, {1, 1}, {0, 1, 0}}, // 17
//    {{-1, 1, -1}, {0, 0, 1, 1}, {0, 1}, {0, 1, 0}}, // 18
//    {{-1, 1, 1}, {0, 0, 0, 1}, {0, 0}, {0, 1, 0}}, // 19
//    
//    // Bottom
//    {{1, -1, -1}, {1, 0, 0, 1}, {1, 0}, {0, -1, 0}}, // 20
//    {{1, -1, 1}, {0, 1, 0, 1}, {1, 1}, {0, -1, 0}}, // 21
//    {{-1, -1, 1}, {0, 0, 1, 1}, {0, 1}, {0, -1, 0}}, // 22
//    {{-1, -1, -1}, {0, 0, 0, 1}, {0, 0}, {0, -1, 0}}, // 23
//};
//
//const GLubyte indices[] = {
//    // Front
//    0, 1, 2,
//    2, 3, 0,
//    // Back
//    4, 5, 6,
//    6, 7, 4,
//    // Left
//    8, 9, 10,
//    10, 11, 8,
//    // Right
//    12, 13, 14,
//    14, 15, 12,
//    // Top
//    16, 17, 18,
//    18, 19, 16,
//    // Bottom
//    20, 21, 22,
//    22, 23, 20
//};
//
@implementation RWTCube
//
//- (instancetype)initWithShader:(TWGLShadersReference *)shader {
//    
//    if ((self = [super initWithName:"cube" shader:shader vertices:(TWGLVertex *)vertices vertexCount:sizeof(vertices)/sizeof(vertices[0]) inidices:(GLubyte *)indices indexCount:sizeof(indices)/sizeof(indices[0])])) {
//        
//        _name = name;
//        _vertexCount = vertexCount;
//        _indexCount = indexCount;
//        _shader = shader;
//        self.position = GLKVector3Make(0, 0, 0);
//        self.rotationX = 0;
//        self.rotationY = 0;
//        self.rotationZ = 0;
//        self.scale = 1.0;
//        self.children = [NSMutableArray array];
//        
//        glGenVertexArraysOES(1, &_vao);
//        glBindVertexArrayOES(_vao);
//        
//        // Generate vertex buffer
//        glGenBuffers(1, &_vertexBuffer);
//        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
//        glBufferData(GL_ARRAY_BUFFER, vertexCount * 1 * sizeof(GL_FLOAT), vertices, GL_STATIC_DRAW);
//        //        glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(GL_FLOAT), vertices, GL_STATIC_DRAW);
//        
//        //        // Generate index buffer
//        //        glGenBuffers(1, &_indexBuffer);
//        //        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//        //        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(GLubyte), indices, GL_STATIC_DRAW);
//        
//        // Enable vertex attributes
//        glEnableVertexAttribArray(TWGLVertexAttribPosition);
//        //        glVertexAttribPointer(TWGLVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT), (const GLvoid *) offsetof(TWGLVertex, Position));
//        glVertexAttribPointer(TWGLVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GL_FLOAT), 0);
//        //        glVertexAttribPointer(TWGLVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT), 0);
//        //        glEnableVertexAttribArray(TWGLVertexAttribColor);
//        //        glVertexAttribPointer(TWGLVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(TWGLVertex), (const GLvoid *) offsetof(TWGLVertex, Color));
//        //        glEnableVertexAttribArray(TWGLVertexAttribTexCoord);
//        //        glVertexAttribPointer(TWGLVertexAttribTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(TWGLVertex), (const GLvoid *) offsetof(TWGLVertex, TexCoord));
//        //        glEnableVertexAttribArray(TWGLVertexAttribNormal);
//        //        glVertexAttribPointer(TWGLVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(TWGLVertex), (const GLvoid *) offsetof(TWGLVertex, Normal));
//        
//        glBindVertexArrayOES(0);
//        glBindBuffer(GL_ARRAY_BUFFER, 0);
//        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
//        
//
//        [self loadTexture:@"dungeon_01.png"];
//    }
//    return self;
//}
//
//- (void)updateWithDelta:(NSTimeInterval)dt {
//    self.rotationY += M_PI/8 * dt;
//}

@end

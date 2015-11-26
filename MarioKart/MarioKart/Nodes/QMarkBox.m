//
//  QMarkBox.m
//  MarioKart
//
//  Created by Txai Wieser on 25/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "QMarkBox.h"
#import "TWGLOBJLoader.h"

@implementation QMarkBox

- (instancetype)initWithShader:(TWGLShadersReference *)shader {
    GLMmodel *model = [TWGLOBJLoader loadOBJ:@"luigi"];
    
//    GLfloat *array = [TWGLOBJLoader parseGLMmodel:&obj];
    
    
    GLMgroup *group = model->groups;
    printf(group->name);
    GLubyte *indicesArray = (GLubyte*)malloc(sizeof(GLubyte)*3*(group->numtriangles));
    
    for (GLuint i = 0; i < group->numtriangles; i++) {
        GLMtriangle *triangle = &T(group->triangles[i]);
        
        GLuint ind = (3*i);
        GLuint um = triangle->vindices[0];
        indicesArray[ind+0] = um;
        GLuint dois = triangle->vindices[1];
        indicesArray[ind+1] = dois;
        GLuint tres = triangle->vindices[2];
        indicesArray[ind+2] = tres;
    }
    
    printf("\n");
    for (int i = 0; i < group->numtriangles*3; i++) {
        printf("%i: %d\n", i, indicesArray[i]);
    }
    
    if ((self = [super initWithName:"qmark" shader:shader vertices:model->vertices vertexCount:model->numvertices inidices:indicesArray indexCount:3*group->numtriangles])) {
        //        [self loadTexture:@"dungeon_01.png"];
        //        self.scale = 0.3;
    }
    return self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    //    self.rotationZ += M_PI/8 * dt;
    //    self.rotationX += M_PI/8 * dt;
}

@end

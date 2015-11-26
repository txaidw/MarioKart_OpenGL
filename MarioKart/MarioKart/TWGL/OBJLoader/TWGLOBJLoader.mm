 //
//  TWGLOBJLoader.m
//  OBJLoader
//
//  Created by Txai Wieser on 09/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLOBJLoader.h"


@implementation TWGLOBJLoader

+ (GLMmodel *)loadOBJ:(NSString *)named {
//    
//    // Read our .obj file
//    std::vector<glm::vec3> vertices;
//    std::vector<glm::vec2> uvs;
//    std::vector<glm::vec3> normals;
//    
    NSString *path = [[NSBundle mainBundle] pathForResource:named ofType:@"obj"];
    
    return glmReadOBJ((char *)path.UTF8String);
}



+ (GLfloat *)parseGLMmodel:(GLMmodel *)model {
    static GLuint i;
    static GLMgroup* group;
    static GLMtriangle* triangle;
    static GLMmaterial* material;
    GLuint IDTextura;
    
    assert(model);
    assert(model->vertices);
    
    IDTextura = -1;
    group = model->groups;

    
    GLMgroup *tt = group;
    GLuint total = 0;
    while (tt) {
        total += tt->numtriangles;
        tt = tt->next;
    }
    GLfloat *totalArray = (GLfloat*)malloc(sizeof(GLfloat)*3*3*(total+1));
    
    GLuint accumulator = 0;
    GLuint index = 0;
    while (group) {
        printf("index: %d\n", index);
        index++;

        for (GLuint i = 0; i < group->numtriangles; i++) {
            triangle = &T(group->triangles[i]);
            
            GLuint ind = 0;
            //            if (mode & GLM_FLAT)
            //                glNormal3fv(&model->facetnorms[3 * triangle->findex]);
            //
            //            if (mode & GLM_SMOOTH)
            //                glNormal3fv(&model->normals[3 * triangle->nindices[0]]);
            //            if (mode & GLM_TEXTURE)
            //                glTexCoord2fv(&model->texcoords[2 * triangle->tindices[0]]);
            ind = accumulator +(3*3*i)+ 0*3;
            totalArray[ind] = model->vertices[3 * triangle->vindices[0]];
            printf("ind %d\n", ind);
//            printf("[%d] p: %d {%d, %d, %d}\n", ind);
            
            //            if (mode & GLM_SMOOTH)
            //                glNormal3fv(&model->normals[3 * triangle->nindices[1]]);
            //            if (mode & GLM_TEXTURE)
            //            {
            //                if (IDTextura==-1) printf("Warning: GLM_TEXTURE este on dar nu este setata nici o textura in material!");
            //                glTexCoord2fv(&model->texcoords[2 * triangle->tindices[1]]);
            //            }
            ind = accumulator +(3*3*i)+ 1*3;
            totalArray[ind] = model->vertices[3 * triangle->vindices[1]];
            printf("ind %d\n", ind);
            //            if (mode & GLM_SMOOTH)
            //                glNormal3fv(&model->normals[3 * triangle->nindices[2]]);
            //            if (mode & GLM_TEXTURE)
            //                glTexCoord2fv(&model->texcoords[2 * triangle->tindices[2]]);
            ind = accumulator +(3*3*i)+ 2*3;
            totalArray[ind] = model->vertices[3 * triangle->vindices[2]];
            printf("ind %d\n", ind);
            
        }
        accumulator += 3*3*group->numtriangles;
        group = group->next;
    }
    return totalArray;
}
@end

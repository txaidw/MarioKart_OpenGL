#import <OpenGLES/ES3/gl.h>

typedef enum {
    TWGLVertexAttribPosition = 0,
    TWGLVertexAttribColor,
    TWGLVertexAttribTexCoord,
    TWGLVertexAttribNormal
} TWGLVertexAttributes;

typedef struct {
    GLfloat Position[3];
    GLfloat Color[4];
    GLfloat TexCoord[2];
    GLfloat Normal[3];
} TWGLVertex;
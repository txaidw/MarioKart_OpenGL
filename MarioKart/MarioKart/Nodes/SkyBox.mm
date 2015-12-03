//
//  SkyBox.m
//  MarioKart
//
//  Created by Txai Wieser on 02/12/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "SkyBox.h"

@implementation SkyBox {
    GLuint n1;
    GLuint n2;
    GLuint n3;
    GLuint n4;
    GLuint n5;
    GLuint n6;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        GLfloat ww, hh;
        
        n6 = glmLoadTexture("MarioKart/Models/SkyBox/floor.tga", false, false, false, true, &ww, &hh);
        n5 = glmLoadTexture("MarioKart/Models/SkyBox/floor.tga", false, false, false, true, &ww, &hh);
        n1 = n2 = n3 = n4 = glmLoadTexture("MarioKart/Models/SkyBox/wall.tga", false, false, false, true, &ww, &hh);

    }
    return self;
}




- (void)render {
    float size = 2800;
    float height = 1000;
    glPushMatrix();
    
    // Enable/Disable features
    glPushAttrib(GL_ENABLE_BIT);
    glEnable(GL_TEXTURE_2D);
    glDisable(GL_DEPTH_TEST);
//    glDisable(GL_LIGHTING);
    glDisable(GL_BLEND);
    
    // Just in case we set all vertices to white.
    glColor4f(1,1,1,1);
    
    // Render the front quad
    glBindTexture(GL_TEXTURE_2D, n1);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f(  0.5*size, -0.0*height, -0.5*size );
    glTexCoord2f(1, 0); glVertex3f( -0.5*size, -0.0*height, -0.5*size );
    glTexCoord2f(1, 1); glVertex3f( -0.5*size,  1.0*height, -0.5*size );
    glTexCoord2f(0, 1); glVertex3f(  0.5*size,  1.0*height, -0.5*size );
    glEnd();
    
    // Render the left quad
    glBindTexture(GL_TEXTURE_2D, n2);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f(  0.5*size, -0.0*height,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size, -0.0*height, -0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size,  1.0*height, -0.5*size );
    glTexCoord2f(0, 1); glVertex3f(  0.5*size,  1.0*height,  0.5*size );
    glEnd();
    
    // Render the back quad
    glBindTexture(GL_TEXTURE_2D, n3);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f( -0.5*size, -0.0*height,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size, -0.0*height,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size,  1.0*height,  0.5*size );
    glTexCoord2f(0, 1); glVertex3f( -0.5*size,  1.0*height,  0.5*size );
    
    glEnd();
    
    // Render the right quad
    glBindTexture(GL_TEXTURE_2D, n4);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f( -0.5*size, -0.0*height, -0.5*size );
    glTexCoord2f(1, 0); glVertex3f( -0.5*size, -0.0*height,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f( -0.5*size,  1.0*height,  0.5*size );
    glTexCoord2f(0, 1); glVertex3f( -0.5*size,  1.0*height, -0.5*size );
    glEnd();
    
    // Render the top quad
    glBindTexture(GL_TEXTURE_2D, n5);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 1); glVertex3f( -0.5*size,  1.0*height, -0.5*size );
    glTexCoord2f(0, 0); glVertex3f( -0.5*size,  1.0*height,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size,  1.0*height,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size,  1.0*height, -0.5*size );
    glEnd();
    
    // Render the bottom quad
    glBindTexture(GL_TEXTURE_2D, n6);
    glBegin(GL_QUADS);
    glTexCoord2f(0, 0); glVertex3f( -0.5*size, -0.0*size, -0.5*size );
    glTexCoord2f(0, 1); glVertex3f( -0.5*size, -0.0*size,  0.5*size );
    glTexCoord2f(1, 1); glVertex3f(  0.5*size, -0.0*size,  0.5*size );
    glTexCoord2f(1, 0); glVertex3f(  0.5*size, -0.0*size, -0.5*size );
    glEnd();
    
    // Restore enable bits and matrix
    glPopAttrib();
    glPopMatrix();

}
@end

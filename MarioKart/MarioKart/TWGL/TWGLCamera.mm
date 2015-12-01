//
//  TWGLCamera.m
//  MarioKart
//
//  Created by Txai Wieser on 23/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "TWGLCamera.h"
#import <GLUT/glut.h>

#define CAMERA_TYPE1_PX 0
#define CAMERA_TYPE1_PY 2.0
#define CAMERA_TYPE1_PZ -3.7

#define CAMERA_TYPE2_PX 0
#define CAMERA_TYPE2_PY 3
#define CAMERA_TYPE2_PZ -12

#define CAMERA_TYPE3_PX 0
#define CAMERA_TYPE3_PY 0.5
#define CAMERA_TYPE3_PZ 1.0

#define CAMERA_TYPES 3

@implementation TWGLCamera {
    int type;
    BOOL ortho;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        type = 1;
        [self loadCameraSettings];
    }
    return self;
}

- (void)setOrtho {
    ortho = TRUE;
}
- (void)render {}

- (void)renderCamera {
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    if (ortho) {
        glOrtho(-500, 500, -500, 500, -3000, 3000);
    } else {
        GLint m_viewport[4];
        
        glGetIntegerv( GL_VIEWPORT, m_viewport);
        
        gluPerspective(45, (float)m_viewport[2]/(float)m_viewport[3], 0.001, 1000);
        
    }
    
    float xx, yy, zz;
    float rx, ry, rz;
    
    [self calculateAbsolutePosition:&xx yy:&yy zz:&zz];
    [self calculateAbsoluteRotation:&rx yy:&ry zz:&rz];
    
    zz -= self.positionZ;
    zz += self.positionZ*cos(ry*M_PI/180.0);
    xx += self.positionZ*sin(ry*M_PI/180.0);
    float distance = 5;
    float yaw = rx;
    float pitch = ry;
    
    float px = distance*sin(yaw*M_PI/180.0)*cos(pitch*M_PI/180.0);
    float py = 0;//
    float pz = distance*cos(yaw*M_PI/180.0);
    
    //    x = cos(yaw)*cos(pitch)
    //    y = sin(yaw)*cos(pitch)
    //    z = sin(pitch)
    Vector3 a = Vector3();
    a.x = rx;
    a.y = ry;
    a.z = rz;
    Vector3 left = Vector3();
    Vector3 up = Vector3();
    Vector3 forward = Vector3();
    
    anglesToAxes(a, left, up, forward);
    
    gluLookAt(xx, yy, zz, // EYE
              xx+forward.x, yy+forward.y, zz+forward.z, // LOOK
              0, 1, 0); // CAMERA UP
    
    
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    //    self.rotationX += 0.5;
}

- (void)changeCameraMode {
    printf("\nCHANGE CAMERA\n");
    type++;
    if (type > CAMERA_TYPES) {
        type = 1;
    }
    [self loadCameraSettings];
}

- (void)loadCameraSettings {
    
    switch (type) {
        case 1:
            self.positionX = CAMERA_TYPE1_PX;
            self.positionY = CAMERA_TYPE1_PY;
            self.positionZ = CAMERA_TYPE1_PZ;
            break;
            
        case 2:
            self.positionX = CAMERA_TYPE2_PX;
            self.positionY = CAMERA_TYPE2_PY;
            self.positionZ = CAMERA_TYPE2_PZ;
            break;
            
        case 3:
            self.positionX = CAMERA_TYPE3_PX;
            self.positionY = CAMERA_TYPE3_PY;
            self.positionZ = CAMERA_TYPE3_PZ;
            break;
            
        default:
            break;
    }
}



struct Vector3
{
    float x;
    float y;
    float z;
    Vector3() : x(0), y(0), z(0) {}; // initialze when created
};


///////////////////////////////////////////////////////////////////////////////
// convert Euler angles(x,y,z) to axes(left, up, forward)
// Each column of the rotation matrix represents left, up and forward axis.
// The order of rotation is Roll->Yaw->Pitch (Rx*Ry*Rz)
// Rx: rotation about X-axis, pitch
// Ry: rotation about Y-axis, yaw(heading)
// Rz: rotation about Z-axis, roll
//    Rx           Ry          Rz
// |1  0   0| | Cy  0 Sy| |Cz -Sz 0|   | CyCz        -CySz         Sy  |
// |0 Cx -Sx|*|  0  1  0|*|Sz  Cz 0| = | SxSyCz+CxSz -SxSySz+CxCz -SxCy|
// |0 Sx  Cx| |-Sy  0 Cy| | 0   0 1|   |-CxSyCz+SxSz  CxSySz+SxCz  CxCy|
///////////////////////////////////////////////////////////////////////////////
void anglesToAxes(const Vector3 angles, Vector3& left, Vector3& up, Vector3& forward)
{
    const float DEG2RAD = 3.141593f / 180;
    float sx, sy, sz, cx, cy, cz, theta;
    
    // rotation angle about X-axis (pitch)
    theta = angles.x * DEG2RAD;
    sx = sinf(theta);
    cx = cosf(theta);
    
    // rotation angle about Y-axis (yaw)
    theta = angles.y * DEG2RAD;
    sy = sinf(theta);
    cy = cosf(theta);
    
    // rotation angle about Z-axis (roll)
    theta = angles.z * DEG2RAD;
    sz = sinf(theta);
    cz = cosf(theta);
    
    // determine left axis
    left.x = cy*cz;
    left.y = sx*sy*cz + cx*sz;
    left.z = -cx*sy*cz + sx*sz;
    
    // determine up axis
    up.x = -cy*sz;
    up.y = -sx*sy*sz + cx*cz;
    up.z = cx*sy*sz + sx*cz;
    
    // determine forward axis
    forward.x = sy;
    forward.y = -sx*cy;
    forward.z = cx*cy;
}

@end

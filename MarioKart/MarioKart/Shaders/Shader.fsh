//
//  Shader.fsh
//  MarioKart
//
//  Created by Txai Wieser on 10/28/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}

//
//  Shader.fsh
//  popo0
//
//  Created by Gennadi Iosad on 15/02/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

varying lowp vec4 colorVarying;
uniform sampler2D img;
void main()
{
    gl_FragColor = colorVarying;
}

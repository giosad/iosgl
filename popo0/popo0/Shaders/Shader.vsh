//
//  Shader.vsh
//  popo0
//
//  Created by Gennadi Iosad on 15/02/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

attribute vec4 position;
attribute vec2 texCoord;
varying lowp vec2 vtexCoord;
varying lowp vec4 colorVarying;
uniform mat4 modelViewProjectionMatrix;
float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
void main()
{
  vec4 diffuseColor = vec4(0.9, 0.4, 0.3, 1.0);
  colorVarying =  diffuseColor;
  
//  colorVarying = vec4(rand(position), 0.3, 0.3, 1.0);
  vec4 p = position;//vec4(position, 0, 0);
  gl_Position = modelViewProjectionMatrix * p;
}

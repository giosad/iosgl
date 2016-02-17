//
//  GameViewController.m
//  popo0
//
//  Created by Gennadi Iosad on 15/02/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "GameViewController.h"
#import "GLShaderMgr.h"
#import <OpenGLES/ES2/glext.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

GLfloat gCubeVertexData[216] =
{
  // Data layout for each line below is:
  // positionX, positionY, positionZ,     normalX, normalY, normalZ,
  0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
  0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
  0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
  0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
  
  0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
  0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
  
  -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
  -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
  -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
  
  -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
  0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
  0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
  
  0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
  -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
  
  0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
  0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
  -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
  -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

@interface GameViewController () {
  
  
  GLKMatrix4 _modelViewProjectionMatrix;
  GLKMatrix3 _normalMatrix;
  float _rotation;
  GLuint _vertexArray;
  GLuint _vertexBuffer;
  
  
  GLuint _glmodelViewProjectionMatrixUniform;
  GLuint _glnormalMatrixUnform;
  
  GLuint _glPositionsAttrib;
  GLuint _glNormalsAttrib;
  
}
@property (strong, nonatomic) GLShaderMgr *shaderHelper;
@property (strong, nonatomic) EAGLContext *context;

@end

@implementation GameViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  
  GLKView *view = (GLKView *)self.view;
  view.context = self.context;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  [self setupGL];
}

- (void)dealloc
{
  [self tearDownGL];
  
  if ([EAGLContext currentContext] == self.context) {
    [EAGLContext setCurrentContext:nil];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  
  if ([self isViewLoaded] && ([[self view] window] == nil)) {
    self.view = nil;
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
      [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
  }
  
  // Dispose of any resources that can be recreated.
}




- (void)setupGL
{
  [EAGLContext setCurrentContext:self.context];
  
  
  self.shaderHelper = [[GLShaderMgr alloc] init];
  [self.shaderHelper loadShadersWithName:@"Shader"];
  _glmodelViewProjectionMatrixUniform = [self.shaderHelper getUniformLocation:@"modelViewProjectionMatrix"];
  _glnormalMatrixUnform = [self.shaderHelper getUniformLocation:@"normalMatrix"];
  _glNormalsAttrib = [self.shaderHelper getAttribLocation:@"normal"];
  _glPositionsAttrib = [self.shaderHelper getAttribLocation:@"position"];
  
  
  glEnable(GL_DEPTH_TEST);
  
  
  //create and bind VAO
  glGenVertexArraysOES(1, &_vertexArray);
  glBindVertexArrayOES(_vertexArray);
  
  //create and bind VBO
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  
  //point VBO to vertex data
  glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
  
  //attrib config for the bound VBO
  glEnableVertexAttribArray(_glPositionsAttrib);
  glVertexAttribPointer(_glPositionsAttrib, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
  
  glEnableVertexAttribArray(_glNormalsAttrib);
  glVertexAttribPointer(_glNormalsAttrib, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
  
  //unbind VAO
  glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
  [EAGLContext setCurrentContext:self.context];
  
  glDeleteBuffers(1, &_vertexBuffer);
  glDeleteVertexArraysOES(1, &_vertexArray);
  
  [self.shaderHelper deleteProgram];
  
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
  float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
  GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
  
  
  // Compute the model matrix for the object
  GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 1.5f);
  modelMatrix = GLKMatrix4Rotate(modelMatrix, _rotation, 1.0f, 1.0f, 1.0f);
  
  //apply camera view mtx
  GLKMatrix4 viewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
  GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
  
  _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
  
  _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
  
  _rotation += self.timeSinceLastUpdate * 0.5f;
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  glBindVertexArrayOES(_vertexArray);

  glUseProgram(self.shaderHelper.program);
  
  glUniformMatrix4fv(_glmodelViewProjectionMatrixUniform, 1, 0, _modelViewProjectionMatrix.m);
  glUniformMatrix3fv(_glnormalMatrixUnform, 1, 0, _normalMatrix.m);
  
  glDrawArrays(GL_TRIANGLES, 0, 36);
}

@end

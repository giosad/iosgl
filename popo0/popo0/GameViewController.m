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




GLfloat gCubeVertexTexCoordData[] =
{
  // Data layout for each line below is:
  // positionX, positionY, tex-x coord, tex-y coord
  -0.5f, -0.5f, 0.0f, 1.0f,
  -0.5f,  0.5f, 0.0f, 0.0f,
   0.5f,  0.5f, 1.0f, 0.0f,
  
  -0.5f, -0.5f, 0.0f, 1.0f,
   0.5f,  0.5f, 1.0f, 0.0f,
   0.5f, -0.5f, 1.0f, 1.0f,
};





@interface GameViewController () {
  
  
  GLKMatrix4 _modelViewProjectionMatrix;

  GLuint _vertexArray;
  GLuint _vertexBuffer;

  GLuint _glmodelViewProjectionMatrixUniform;
  GLuint _glPositionsAttrib;
  GLuint _glTexCoordAttrib;
  
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
  _glPositionsAttrib = [self.shaderHelper getAttribLocation:@"position"];
  _glTexCoordAttrib = [self.shaderHelper getAttribLocation:@"texCoord"];
  
  
  //create and bind VAO
  glGenVertexArraysOES(1, &_vertexArray);
  glBindVertexArrayOES(_vertexArray);
  
  //create and bind VBO
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  
  //point VBO to vertex and tex coords data
  glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexTexCoordData), gCubeVertexTexCoordData, GL_STATIC_DRAW);
  

  //attrib config for the bound VBO
  glEnableVertexAttribArray(_glPositionsAttrib);
  glVertexAttribPointer(_glPositionsAttrib, 2, GL_FLOAT, GL_FALSE, 2*sizeof(GLfloat), BUFFER_OFFSET(0));


  //attrib config for the bound VBO
//  glEnableVertexAttribArray(_glTexCoordAttrib);
//  glVertexAttribPointer(_glTexCoordAttrib, 2, GL_FLOAT, GL_FALSE, 2*sizeof(GLfloat), BUFFER_OFFSET(2*sizeof(GLfloat)));
//
//  
  //unbind VAO
  glBindVertexArrayOES(0);}

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
  GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(-10, 10, -10, 10, -1, 1);
  
  
  // Compute the model matrix for the object
  GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
  
  //apply camera view mtx
  GLKMatrix4 viewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -0.5f);
  GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
  
  
  _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
  
}

#define NELEMENTS(x) (sizeof(x)/sizeof(x[0]))

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
  glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  glBindVertexArrayOES(_vertexArray);

  glUseProgram(self.shaderHelper.program);
  
  glUniformMatrix4fv(_glmodelViewProjectionMatrixUniform, 1, 0, _modelViewProjectionMatrix.m);

  
//  glDrawArrays(GL_TRIANGLES, 0, 6);
  glDrawArrays(GL_TRIANGLES, 0, 3);

}

@end

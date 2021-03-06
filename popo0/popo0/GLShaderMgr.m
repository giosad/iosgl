// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "GLShaderMgr.h"

NS_ASSUME_NONNULL_BEGIN
@interface GLShaderMgr()
@property (nonatomic, readwrite) GLuint program;
@end
@implementation GLShaderMgr


#pragma mark -  OpenGL ES 2 shader compilation

- (void) deleteProgram {
  if (self.program) {
    glDeleteProgram(self.program);
    self.program = 0;
  }
}


- (BOOL)loadShadersWithName:(NSString*)name{
  GLuint vertShader, fragShader;
  NSString *vertShaderPathname, *fragShaderPathname;
  
  // Create shader program.
  self.program = glCreateProgram();
  
  // Create and compile vertex shader.
  vertShaderPathname = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
  if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
    NSLog(@"Failed to compile vertex shader");
    return NO;
  }
  
  // Create and compile fragment shader.
  fragShaderPathname = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
  if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
    NSLog(@"Failed to compile fragment shader");
    return NO;
  }
  
  // Attach vertex shader to program.
  glAttachShader(self.program, vertShader);
  
  // Attach fragment shader to program.
  glAttachShader(self.program, fragShader);
  

  // Link program.
  if (![self linkProgram:self.program]) {
    NSLog(@"Failed to link program: %d", self.program);
    
    if (vertShader) {
      glDeleteShader(vertShader);
      vertShader = 0;
    }
    if (fragShader) {
      glDeleteShader(fragShader);
      fragShader = 0;
    }
    if (self.program) {
      glDeleteProgram(self.program);
      self.program = 0;
    }
    
    return NO;
  }
  

  // Release vertex and fragment shaders.
  if (vertShader) {
    glDetachShader(self.program, vertShader);
    glDeleteShader(vertShader);
  }
  if (fragShader) {
    glDetachShader(self.program, fragShader);
    glDeleteShader(fragShader);
  }
  
  return YES;
}

- (GLuint) getUniformLocation:(NSString*)uniformName{
  return glGetUniformLocation(self.program, [uniformName UTF8String]);
}

- (GLuint) getAttribLocation:(NSString*)attribName{
  return glGetAttribLocation(self.program, [attribName UTF8String]);
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
  GLint status;
  const GLchar *source;
  
  source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
  if (!source) {
    NSLog(@"Failed to load vertex shader");
    return NO;
  }
  
  *shader = glCreateShader(type);
  glShaderSource(*shader, 1, &source, NULL);
  glCompileShader(*shader);
  
#if defined(DEBUG)
  GLint logLength;
  glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetShaderInfoLog(*shader, logLength, &logLength, log);
    NSLog(@"Shader compile log:\n%s", log);
    free(log);
  }
#endif
  
  glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
  if (status == 0) {
    glDeleteShader(*shader);
    return NO;
  }
  
  return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
  GLint status;
  glLinkProgram(prog);
  
#if defined(DEBUG)
  GLint logLength;
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program link log:\n%s", log);
    free(log);
  }
#endif
  
  glGetProgramiv(prog, GL_LINK_STATUS, &status);
  if (status == 0) {
    return NO;
  }
  
  return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
  GLint logLength, status;
  
  glValidateProgram(prog);
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0) {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program validate log:\n%s", log);
    free(log);
  }
  
  glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
  if (status == 0) {
    return NO;
  }
  
  return YES;
}


@end

NS_ASSUME_NONNULL_END

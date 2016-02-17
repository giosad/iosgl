// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
@import Foundation;
#import <OpenGLES/ES2/glext.h>
NS_ASSUME_NONNULL_BEGIN

@interface ShaderHelper : NSObject
- (instancetype)init;
- (BOOL)deleteProgram;
@property (nonatomic, readonly) GLuint program;

@end

NS_ASSUME_NONNULL_END

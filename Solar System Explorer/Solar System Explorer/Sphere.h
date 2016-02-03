//
//  Sphere.h
//  InnerPlanets
//
//  Created by Jarret Francis Kolanko on 2015-03-10.
//  Copyright (c) 2015 Jarret Francis Kolanko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES2/glext.h>

enum {
    ATTRIBUTE_POSITION,
    ATTRIBUTE_NORMAL,
    ATTRIBUTE_COLOR,
    ATTRIBUTE_TEXCOORDINATE,
    ATTRIBUTE_TANGENT,
    ATTRIBUTE_BITANGENT,
    
    NUMBER_OF_ATTRIBUTESs
};

@interface  Sphere : NSObject

-(Sphere*) init: (int) seg;
-(void) dealloc;
-(void) drawOpenGLES1;

-(void) drawOpenGLES2;
-(void) createVertexBufferObject;
-(void) createTangentVBO;

-(void) setCenter: (CGPoint) pnt;
-(CGPoint) Center;
@end
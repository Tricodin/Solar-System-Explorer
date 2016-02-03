//
//  ImageTexture.h
//  InnerPlanets
//
//  Created by Jarret Francis Kolanko on 2015-03-10.
//  Copyright (c) 2015 Jarret Francis Kolanko. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <ImageIO/ImageIO.h>
#import <UIKit/UIKit.h>

@interface ImageTexture : NSObject

- (ImageTexture*) initFrom: (NSString *)file;
- (void) dealloc;
- (void) reloadFrom: (NSString *) file;
- (void) bind;
- (void) bindToUnit: (int)unit;

@end
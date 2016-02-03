//
//  ViewController.h
//  InnerPlanets
//
//  Created by Jarret Francis Kolanko on 2015-03-09.
//  Copyright (c) 2015 Jarret Francis Kolanko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "PlanetView.h"

@interface PlanetViewController : GLKViewController

#define kMOTIONUPDATEINTERVAL 15.0
@property (nonatomic, strong) UIView *viewAccX;
@property (nonatomic, strong) UIView *viewAccY;
@property (nonatomic, strong) UIView *viewAccZ;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *viewButton;
@property (nonatomic, strong) UIButton *planetInfo;
- (void)startMonitoringMotion;
- (void)stopMonitoringMotion;
@end


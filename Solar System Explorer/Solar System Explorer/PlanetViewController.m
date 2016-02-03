
//
//  ViewController.m
//  InnerPlanets
//
//  Created by Jarret Francis Kolanko on 2015-03-09.
//  Copyright (c) 2015 Jarret Francis Kolanko. All rights reserved.
//

#import "PlanetViewController.h"
#import "Sphere.h"
#import "CMDisplayView.h"
#import "ImageTexture.h"
#import <CoreMotion/CMMotionManager.h>

@interface PlanetViewController () {
    int _touchArea;

    CGPoint _moveDist[10];

    Sphere *_sunModel;
    ImageTexture *_sunTexture;
    
    Sphere *_mercuryModel;
    ImageTexture *_mercuryTexture;
    
    Sphere *_venusModel;
    ImageTexture *_venusTexture;
    
    Sphere *_earthModel;
    ImageTexture *_earthTexture;
    
    Sphere *_moonModel;
    ImageTexture *_moonTexture;
    
    Sphere *_marsModel;
    ImageTexture *_marsTexture;
    
    Sphere *_jupiterModel;
    ImageTexture *_jupiterTexture;
    
    Sphere *_saturnModel;
    ImageTexture *_saturnTexture;
    
    Sphere *_uranusModel;
    ImageTexture *_uranusTexture;
    
    Sphere *_neptuneModel;
    ImageTexture *_neptuneTexture;
    

    float sun_about_sun;
    float sun_height;
    float sun_width;
    float sun_spin;
    int sun_touched;
    
    float mercury_about_sun;
    float mercury_about_mercury;
    float mercury_dist_sun;
    float mercury_height;
    float mercury_width;
    float mercury_spin;
    float mercury_move;
    int mercury_touched;
    
    float venus_about_sun;
    float venus_about_venus;
    float venus_dist_sun;
    float venus_width;
    float venus_height;
    float venus_spin;
    float venus_move;
    int venus_touched;
    
    float earth_about_sun;
    float earth_about_earth;
    float earth_dist_sun;
    float earth_height;
    float earth_width;
    float earth_spin;
    float earth_move;
    int earth_touched;
    
    float moon_about_earth;
    float moon_about_moon;
    float moon_dist_earth;
    float moon_height;
    float moon_width;
    float moon_spin;
    float moon_move;
    int moon_touched;
    
    float mars_about_sun ;
    float mars_about_mars;
    float mars_dist_sun;
    float mars_height;
    float mars_width;
    float mars_spin;
    float mars_move;
    int mars_touched;
    
    float jupiter_about_sun ;
    float jupiter_about_jupiter;
    float jupiter_dist_sun;
    float jupiter_height;
    float jupiter_width;
    float jupiter_spin;
    float jupiter_move;
    int jupiter_touched;
    
    float saturn_about_sun ;
    float saturn_about_saturn ;
    float saturn_dist_sun ;
    float saturn_height;
    float saturn_width;
    float saturn_spin;
    float saturn_move;
    int saturn_touched;
    
    float uranus_about_sun;
    float uranus_about_uranus;
    float uranus_dist_sun ;
    float uranus_height;
    float uranus_width;
    float uranus_spin;
    float uranus_move;
    int uranus_touched;
    
    float neptune_about_sun;
    float neptune_about_neptune;
    float neptune_dist_sun;
    float neptune_height;
    float neptune_width;
    float neptune_spin;
    float neptune_move;
    int neptune_touched;
    
    float touched_about_sun;
    float touched_about_self;
    float touched_dist_sun;
    float touched_height;
    float touched_width;
    float touched_spin;
    float touched_move;
    
    float window_height;
    float window_width;

    CGPoint tapLocation;
    GLfloat _moveRate, _velX, _velZ;
    GLfloat _turnRate, _rotH, _rotV;
    CGPoint _leftInit, _rightInit;
    UITouch *_leftTouch, *_rightTouch;
    
    float _avgX, _avgY, _avgZ;
    float _varX, _varY, _varZ;
    CGFloat _accX, _accY, _accZ;
    float xtilt, ytilt;
    float xtrans, ytrans;
    float zoom;
    bool allow_tilt;
    NSString *infoText;
}

@property(strong, nonatomic) EAGLContext *context;
@property (nonatomic, strong) CMMotionManager *motman;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CMDisplayView *myView;

-(void)setupGL;
-(void)tearDownGL;
-(void)setupOrthographicView: (CGSize)size;
-(void)addAcceleration:(CMAcceleration)acc;

@end

@implementation PlanetViewController

@synthesize motman, timer, myView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
    
    if(!self.context){
        NSLog(@"Failed to create ES context");
    }

    PlanetView *view = (PlanetView *)self.view;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [view addGestureRecognizer:pinch];
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [self refreshUIforCMDataWithX:0 y:0 z:0];
    [self setupGL];
}


- (void) dealloc{
    [self tearDownGL];
    
    if( [EAGLContext currentContext] == self.context){
        [EAGLContext setCurrentContext:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
}

- (void)update {
    [self setupOrthographicView:self.view.bounds.size];
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    _sunModel = [[Sphere alloc] init:16];
    _sunTexture = [[ImageTexture alloc] initFrom:@"sun.png"];
    
    _mercuryModel = [[Sphere alloc] init:16];
    _mercuryTexture = [[ImageTexture alloc] initFrom:@"Mercury.png"];
    
    _venusModel = [[Sphere alloc] init:16];
    _venusTexture = [[ImageTexture alloc] initFrom:@"Venus.png"];

    _earthModel = [[Sphere alloc] init:16];
    _earthTexture = [[ImageTexture alloc] initFrom:@"earth.png"];

    _moonModel = [[Sphere alloc] init:16];
    _moonTexture = [[ImageTexture alloc] initFrom:@"moon.png"];
    
    _marsModel = [[Sphere alloc] init:16];
    _marsTexture = [[ImageTexture alloc] initFrom:@"Mars.png"];
    
    _jupiterModel = [[Sphere alloc] init:16];
    _jupiterTexture = [[ImageTexture alloc] initFrom:@"Jupiter.png"];
    
    _saturnModel = [[Sphere alloc] init:16];
    _saturnTexture = [[ImageTexture alloc] initFrom:@"Saturn.png"];
    
    _uranusModel = [[Sphere alloc] init:16];
    _uranusTexture = [[ImageTexture alloc] initFrom:@"Uranus.png"];
    
    _neptuneModel = [[Sphere alloc] init:16];
    _neptuneTexture = [[ImageTexture alloc] initFrom:@"Neptune.png"];
    
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);
    
    _moveRate = .001, _turnRate = .0002;
    
    for( int i =0; i<((sizeof _moveDist)/(sizeof _moveDist[0])); i++){
        _moveDist[i].x = self.view.bounds.size.width/2;
        _moveDist[i].y = self.view.bounds.size.height/2;
    }
    [_sunModel setCenter:_moveDist[0]];
    sun_about_sun = 0;
    sun_height = 1.25;
    sun_width = 1.25;
    sun_spin = 0.3;
    sun_touched = 0;
    
    [_earthModel setCenter:_moveDist[3]];
    earth_about_sun = 0;
    earth_about_earth = 0;
    earth_height = 1;
    earth_width = 1;
    earth_dist_sun = 10;
    earth_spin = 1;
    earth_move = 0.25;
    earth_touched = 0;
    
    [_mercuryModel setCenter:_moveDist[1]];
    mercury_about_sun = 90;
    mercury_about_mercury = 0;
    mercury_height = earth_height * 0.383;
    mercury_width = earth_width * 0.383;
    mercury_dist_sun = earth_dist_sun * 0.387;
    mercury_spin = .3;
    mercury_move = earth_move * (1/0.24);
    mercury_touched = 0;
    
    [_venusModel setCenter:_moveDist[2]];
    venus_about_sun = 180;
    venus_about_venus = 0;
    venus_height = earth_height * 0.950;
    venus_width = earth_width * 0.950;
    venus_dist_sun = earth_dist_sun * 0.723;
    venus_spin = .3;
    venus_move = earth_move * (1/0.615);
    venus_touched = 0;

    [_moonModel setCenter:_moveDist[4]];
    moon_about_earth = 270;
    moon_about_moon = 0;
    moon_height = earth_width * 0.273;
    moon_width = earth_width * 0.273;
    moon_dist_earth = earth_dist_sun * 0.15;
    moon_spin = earth_move * (1/0.0748);
    moon_move = earth_move * (1/0.0748);
    moon_touched = 0;
    
    [_marsModel setCenter: _moveDist[5]];
    mars_about_sun = 0;
    mars_about_mars = 0;
    mars_height = earth_width * 0.532;
    mars_width = earth_width * 0.532;
    mars_dist_sun = earth_dist_sun * 1.524;
    mars_spin = .5;
    mars_move = earth_move * (1/1.881);
    mars_touched = 0;
    
    [_jupiterModel setCenter:_moveDist[6]];
    jupiter_about_sun = 90;
    jupiter_about_jupiter = 0;
    jupiter_height = earth_height * 11.19;
    jupiter_width = earth_width * 11.19;
    jupiter_dist_sun = earth_dist_sun * 5.203;
    jupiter_spin = 2.0;
    jupiter_move = earth_move * (1/11.86);
    jupiter_touched = 0;
    
    [_saturnModel setCenter:_moveDist[7]];
    saturn_about_sun = 180;
    saturn_about_saturn = 0;
    saturn_height = earth_height * 9.26;
    saturn_width = earth_width * 9.26;
    saturn_dist_sun = earth_dist_sun * 9.529;
    saturn_spin = 2.2;
    saturn_move = earth_move * (1/29.41);
    saturn_touched = 0;
    
    [_uranusModel setCenter:_moveDist[8]];
    uranus_about_sun = 270;
    uranus_about_uranus = 0;
    uranus_height = earth_height * 4.01;
    uranus_width = earth_width * 4.01;
    uranus_dist_sun = earth_dist_sun * 19.19;
    uranus_spin = 1.6;
    uranus_move = earth_move * (1/84.04);
    uranus_touched = 0;
    
    [_neptuneModel setCenter:_moveDist[9]];
    neptune_about_sun = 0;
    neptune_about_neptune = 0;
    neptune_height = earth_height * 0.950;
    neptune_width = earth_width * 0.950;
    neptune_dist_sun = earth_dist_sun * 30.06;
    neptune_spin = 1.7;
    neptune_move = earth_move * (1/164.8);
    neptune_touched = 0;
    
    xtrans = 0;
    ytrans = 0;
    zoom = 1;
    allow_tilt = true;
    glClearColor(0, 0, 0, 1);
    glClearDepthf(1);
    
    self.resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.resetButton addTarget:self
                        action:@selector(resetButtonTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    self.resetButton.layer.cornerRadius = 10;
    self.resetButton.layer.masksToBounds = YES;
    [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    float wid = self.view.bounds.size.width/4;
    float heig = self.view.bounds.size.height/10;
    float xStPnt = self.view.bounds.origin.x;
    float yStPnt = self.view.bounds.origin.y + self.view.bounds.size.height - heig;
    self.resetButton.frame = CGRectMake(xStPnt,yStPnt,wid,heig);
    self.resetButton.backgroundColor = [UIColor colorWithRed:0.2572428 green:0.93370237 blue:1 alpha:1.0f];
    [self.view addSubview:self.resetButton];
    
    self.viewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.viewButton addTarget:self
                         action:@selector(planetsButtonTapped:)
               forControlEvents:UIControlEventTouchUpInside];
    self.viewButton.layer.cornerRadius = 10;
    self.viewButton.layer.masksToBounds = YES;
    [self.viewButton setTitle:@"Planets" forState:UIControlStateNormal];
    [self.viewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    float xStPnt2 = self.view.bounds.origin.x + self.view.bounds.size.width - wid;
    float yStPnt2 = self.view.bounds.origin.y + self.view.bounds.size.height - heig;
    self.viewButton.frame = CGRectMake(xStPnt2,yStPnt2,wid,heig);
    self.viewButton.backgroundColor = [UIColor colorWithRed:0.2572428 green:0.93370237 blue:1 alpha:1.0f];
    [self.view addSubview:self.viewButton];
    
    self.planetInfo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.planetInfo addTarget:self
                        action:@selector(planetInfoTapped:)
              forControlEvents:UIControlEventTouchUpInside];
    self.planetInfo.layer.cornerRadius = 10;
    self.planetInfo.layer.masksToBounds = YES;
    [self.planetInfo setTitle:infoText forState:UIControlStateNormal];
    [self.planetInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.planetInfo.frame = CGRectMake(wid + 1,yStPnt2,xStPnt2 - wid - 2 ,heig);
    self.planetInfo.backgroundColor = [UIColor colorWithRed:0.2572428 green:0.93370237 blue:1 alpha:1.0f];
    [self.view addSubview:self.planetInfo];
}

-(void) tearDownGL{
    [EAGLContext setCurrentContext:self.context];
}

-(void) setupOrthographicView:(CGSize)size{
    glViewport(0,0, size.width, size.height);
    int window = sun_touched || mercury_touched || venus_touched || earth_touched || mars_touched  ? 8 : 15;
    float min = MIN(size.width, size.height);
    window_width = window*size.width/min;
    window_height = window*size.height/min;
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-window_width * zoom, window_width * zoom, -window_height * zoom, window_height * zoom, -2, 2);
}

-(void)setupSunLight {
    float grey[] = {.5, .5, .5, 1};
    float white[] = {1, 1, 1, 1};
    
    glLightModelf(GL_LIGHT_MODEL_TWO_SIDE, GL_FALSE);
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, grey);
    
    float mercPos[] = {cos((mercury_about_sun* M_PI/180)+ M_PI),sin((mercury_about_sun*M_PI/180) + M_PI),0,0};
    glLightfv(GL_LIGHT0, GL_POSITION, mercPos);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT0, GL_SPECULAR, white);
    glLightfv(GL_LIGHT0, GL_AMBIENT, grey);

    float venusPos[] = {cos((venus_about_sun* M_PI/180)+ M_PI),sin((venus_about_sun*M_PI/180) + M_PI),0,0};
    glLightfv(GL_LIGHT1, GL_POSITION, venusPos);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT1, GL_SPECULAR, white);
    glLightfv(GL_LIGHT1, GL_AMBIENT, grey);
    
    float earthPos[] = {cos((earth_about_sun* M_PI/180)+ M_PI),sin((earth_about_sun*M_PI/180) + M_PI),0,0};
    glLightfv(GL_LIGHT2, GL_POSITION, earthPos);
    glLightfv(GL_LIGHT2, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT2, GL_SPECULAR, white);
    glLightfv(GL_LIGHT2, GL_AMBIENT, grey);
    
    float neptunePos[] = {cos((neptune_about_sun* M_PI/180)+ M_PI),sin((neptune_about_sun*M_PI/180) + M_PI),0,0};
    glLightfv(GL_LIGHT3, GL_POSITION, neptunePos);
    glLightfv(GL_LIGHT3, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT3, GL_SPECULAR, white);
    glLightfv(GL_LIGHT3, GL_AMBIENT, grey);
    
    float marsPos[] = {cos((mars_about_sun* M_PI/180)+ M_PI),sin((mars_about_sun*M_PI/180) + M_PI),0,0};
    glLightfv(GL_LIGHT4, GL_POSITION, marsPos);
    glLightfv(GL_LIGHT4, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT4, GL_SPECULAR, white);
    glLightfv(GL_LIGHT4, GL_AMBIENT, grey);
    
    float jupiterPos[] = {cos((jupiter_about_sun* M_PI/180)+ M_PI),sin((jupiter_about_sun*M_PI/180) + M_PI),0,0};
    glLightfv(GL_LIGHT5, GL_POSITION, jupiterPos);
    glLightfv(GL_LIGHT5, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT5, GL_SPECULAR, white);
    glLightfv(GL_LIGHT5, GL_AMBIENT, grey);
    
    float saturnPos[] = {cos((saturn_about_sun* M_PI/180)+ M_PI),sin((saturn_about_sun*M_PI/180) + M_PI),0,0};
    glLightfv(GL_LIGHT6, GL_POSITION, saturnPos);
    glLightfv(GL_LIGHT6, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT6, GL_SPECULAR, white);
    glLightfv(GL_LIGHT6, GL_AMBIENT, grey);
    
    float uranusPos[] = {cos((uranus_about_sun* M_PI/180)+ M_PI),sin((uranus_about_sun*M_PI/180) + M_PI),0,0};
    glLightfv(GL_LIGHT7, GL_POSITION, uranusPos);
    glLightfv(GL_LIGHT7, GL_DIFFUSE, white);
    glLightfv(GL_LIGHT7, GL_SPECULAR, white);
    glLightfv(GL_LIGHT7, GL_AMBIENT, grey);
    
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    float diffuse[]  = {.5,.5,.5,1};
    float specular[] = {.1,.1,.1,1};
    
    glEnableClientState(GL_VERTEX_ARRAY);
    
    glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuse);
    glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specular);
    glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 5);
    
    if(sun_touched){
        [self setTouched:0];
    }
    else if(mercury_touched){
        [self setTouched:1];
    }
    else if(venus_touched){
        [self setTouched:2];
    }
    else if(earth_touched){
        [self setTouched:3];
    }
    else if(mars_touched){
        [self setTouched:4];
    }
    else if(jupiter_touched){
        [self setTouched:5];
    }
    else if(saturn_touched){
        [self setTouched:6];
    }
    else if(uranus_touched){
        [self setTouched:7];
    }
    else if(neptune_touched){
        [self setTouched:8];
    }
    else{
        [self setTouched:-1];
    }
    
    [self focusedDraw];
    
    if (ytilt > .3 && allow_tilt){
        ytrans += zoom;
    }
    else if(ytilt < -.3 && allow_tilt){
        ytrans += -zoom;
    }
    if (xtilt > .3 && allow_tilt){
        xtrans += zoom;
    }
    else if(xtilt < -.3 && allow_tilt){
        xtrans += -zoom;
    }
    glTranslatef(xtrans, ytrans, 0);
    
    glPushMatrix(); {
        
        glScalef(sun_width, sun_height , 1);
        
        glRotatef(sun_about_sun,0,0,1);
        
        [_sunTexture bind];
        [_sunModel drawOpenGLES1];
    }
    glPopMatrix();
    sun_about_sun = sun_about_sun > 360 ? sun_about_sun - 360 + sun_spin : sun_about_sun + sun_spin;
    
    [self setupSunLight];
    
    glPushMatrix(); {
        glEnable(GL_LIGHTING);
        
        glRotatef(mercury_about_sun, 0, 0, 1);
        glTranslatef(mercury_dist_sun, 0, 0);
        glRotatef(mercury_about_mercury, 0, 0, 1);
        
        glScalef(mercury_width, mercury_height , 1);
        
        glEnable(GL_LIGHT0);
        
        [_mercuryTexture bind];
        [_mercuryModel drawOpenGLES1];
        
        glDisable(GL_LIGHT0);
        glDisable(GL_LIGHTING);
    }
    glPopMatrix();
    mercury_about_mercury = mercury_about_mercury > 360 ? mercury_about_mercury - 360 + mercury_spin : mercury_about_mercury + mercury_spin;
    mercury_about_sun = mercury_about_sun > 360 ? mercury_about_sun - 360 + mercury_move : mercury_about_sun + mercury_move;
    
    
    
    glPushMatrix(); {
        glEnable(GL_LIGHTING);
        
        glRotatef(venus_about_sun, 0,0,1);
        glTranslatef(venus_dist_sun, 0, 0);
        glRotatef(venus_about_venus, 0, 0, 1);
        
        glScalef(venus_width, venus_height , 1);
        
        glEnable(GL_LIGHT1);
        
        [_venusTexture bind];
        [_venusModel drawOpenGLES1];
        
        glDisable(GL_LIGHT1);
        glDisable(GL_LIGHTING);
    }
    glPopMatrix();
    venus_about_venus = venus_about_venus > 360 ? venus_about_venus - 360 + venus_spin : venus_about_venus + venus_spin;
    venus_about_sun = venus_about_sun > 360 ? venus_about_sun - 360 + venus_move : venus_about_sun + venus_move;
    
    
    glPushMatrix(); {
        glEnable(GL_LIGHTING);
        
        glRotatef(earth_about_sun, 0 , 0 ,1);
        glTranslatef(earth_dist_sun, 0, 0);
        glRotatef(earth_about_earth, 0, 0, 1);
    
        glScalef(earth_width, earth_height, 1);
        
        glEnable(GL_LIGHT2);
        
        [_earthTexture bind];
        [_earthModel drawOpenGLES1];
        
        glDisable(GL_LIGHT2);
        glDisable(GL_LIGHTING);
    }
    earth_about_earth = earth_about_earth > 360 ? earth_about_earth - 360 + earth_spin : earth_about_earth + earth_spin;
    earth_about_sun = earth_about_sun > 360 ? earth_about_sun - 360 + earth_move : earth_about_sun + earth_move;
    
    glPushMatrix(); {
        glEnable(GL_LIGHTING);
        
        glRotatef(moon_about_earth, 0 , 0 ,-1);
        glTranslatef(moon_dist_earth, 0, 0);
        glRotatef(moon_about_moon, 0, 0, 1);
        
        glScalef(moon_width, moon_height, 1);
        
        glEnable(GL_LIGHT2);
        
        [_moonTexture bind];
        [_moonModel drawOpenGLES1];
        
        glDisable(GL_LIGHT2);
        glDisable(GL_LIGHTING);
    }
    glPopMatrix();
    glPopMatrix();

    moon_about_moon = moon_about_moon > 360 ? moon_about_moon - 360 + moon_spin : moon_about_moon + moon_spin;
    moon_about_earth = moon_about_earth > 360 ? moon_about_earth - 360 + moon_move : moon_about_earth + moon_move;

    
    glPushMatrix(); {
        glEnable(GL_LIGHTING);
        
        glRotatef(mars_about_sun, 0, 0, 1);
        glTranslatef(mars_dist_sun, 0 , 0);
        glRotatef(mars_about_mars, 0, 0, 1);

        glScalef(mars_width, mars_height, 1);

        glEnable(GL_LIGHT4);
        
        [_marsTexture bind];
        [_marsModel drawOpenGLES1];
        
        glDisable(GL_LIGHT4);
        glDisable(GL_LIGHTING);
    }
    glPopMatrix();
    mars_about_mars = mars_about_mars > 360 ? mars_about_mars - 360 + mars_spin : mars_about_mars + mars_spin;
    mars_about_sun = mars_about_sun > 360 ? mars_about_sun - 360 + mars_move : mars_about_sun + mars_move;
    
    glPushMatrix(); {
        glEnable(GL_LIGHTING);
        
        glRotatef(jupiter_about_sun, 0, 0, 1);
        glTranslatef(jupiter_dist_sun, 0 , 0);
        glRotatef(jupiter_about_jupiter, 0, 0, 1);
        
        glScalef(jupiter_width, jupiter_height, 1);
        
        glEnable(GL_LIGHT5);
        
        [_jupiterTexture bind];
        [_jupiterModel drawOpenGLES1];
        
        glDisable(GL_LIGHT5);
        glDisable(GL_LIGHTING);
    }
    glPopMatrix();
    jupiter_about_jupiter = jupiter_about_jupiter > 360 ? jupiter_about_jupiter - 360 + jupiter_spin : jupiter_about_jupiter + jupiter_spin;
    jupiter_about_sun = jupiter_about_sun > 360 ? jupiter_about_sun - 360 + jupiter_move : jupiter_about_sun + jupiter_move;
    
    glPushMatrix(); {
        glEnable(GL_LIGHTING);
        
        glRotatef(saturn_about_sun, 0, 0, 1);
        glTranslatef(saturn_dist_sun, 0 , 0);
        glRotatef(saturn_about_saturn, 0, 0, 1);
        
        glScalef(saturn_width, saturn_height, 1);
        
        glEnable(GL_LIGHT6);
        
        [_saturnTexture bind];
        [_saturnModel drawOpenGLES1];
        
        glDisable(GL_LIGHT6);
        glDisable(GL_LIGHTING);
    }
    glPopMatrix();
    saturn_about_saturn = saturn_about_saturn > 360 ? saturn_about_saturn - 360 + saturn_spin : saturn_about_saturn + saturn_spin;
    saturn_about_sun = saturn_about_sun > 360 ? saturn_about_sun - 360 + saturn_move : saturn_about_sun + saturn_move;
    
    glPushMatrix(); {
        glEnable(GL_LIGHTING);
        
        glRotatef(uranus_about_sun, 0, 0, 1);
        glTranslatef(uranus_dist_sun, 0 , 0);
        glRotatef(uranus_about_uranus, 0, 0, 1);
        
        glScalef(uranus_width, uranus_height, 1);
        
        glEnable(GL_LIGHT7);
        
        [_uranusTexture bind];
        [_uranusModel drawOpenGLES1];
        
        glDisable(GL_LIGHT7);
        glDisable(GL_LIGHTING);
    }
    glPopMatrix();
    uranus_about_uranus = saturn_about_saturn > 360 ? uranus_about_uranus - 360 + uranus_spin : uranus_about_uranus + uranus_spin;
    uranus_about_sun = uranus_about_sun > 360 ? uranus_about_sun - 360 + uranus_move : uranus_about_sun + uranus_move;
    
    glPushMatrix(); {
        glEnable(GL_LIGHTING);

        glRotatef(neptune_about_sun, 0, 0, 1);
        glTranslatef(neptune_dist_sun, 0 , 0);
        glRotatef(neptune_about_neptune, 0, 0, 1);
        
        glScalef(saturn_width, saturn_height, 1);
        
        float grey[] = {.5, .5, .5, 1};
        float white[] = {1, 1, 1, 1};
        float neptunePos[] = {cos((neptune_about_sun* M_PI/180)+ M_PI),sin((neptune_about_sun*M_PI/180) + M_PI),0,0};
        glLightfv(GL_LIGHT0, GL_POSITION, neptunePos);
        glLightfv(GL_LIGHT0, GL_DIFFUSE, white);
        glLightfv(GL_LIGHT0, GL_SPECULAR, white);
        glLightfv(GL_LIGHT0, GL_AMBIENT, grey);
        
        glEnable(GL_LIGHT3);
        
        [_neptuneTexture bind];
        [_neptuneModel drawOpenGLES1];
        
        glDisable(GL_LIGHT3);
        glDisable(GL_LIGHTING);
    }
    glPopMatrix();
    neptune_about_neptune = neptune_about_neptune > 360 ? neptune_about_neptune - 360 + neptune_spin : neptune_about_neptune + neptune_spin            ;
    neptune_about_sun = neptune_about_sun > 360 ? neptune_about_sun - 360 + neptune_move : neptune_about_sun + neptune_move;
}


-(void) resetButtonTapped:(UIButton *)button{
    sun_touched = 0;
    mercury_touched = 0;
    venus_touched = 0;
    earth_touched = 0;
    moon_touched = 0;
    mars_touched = 0;
    jupiter_touched = 0;
    saturn_touched = 0;
    uranus_touched = 0;
    neptune_touched = 0;
    allow_tilt = true;
    xtrans = 0;
    ytrans = 0;
    zoom = 1;
}

-(void) planetsButtonTapped:(UIButton *)button{
    xtrans = 0;
    ytrans = 0;
    if(sun_touched){
        sun_touched = 0;
        mercury_touched = 1;
    }
    else if(mercury_touched){
        mercury_touched = 0;
        venus_touched = 1;;
    }
    else if(venus_touched){
        venus_touched = 0;
        earth_touched = 1;
    }
    else if(earth_touched){
        earth_touched = 0;
        mars_touched = 1;
    }
    else if(mars_touched){
        mars_touched = 0;
        jupiter_touched = 1;
    }
    else if(jupiter_touched){
        jupiter_touched = 0;
        saturn_touched = 1;
    }
    else if(saturn_touched){
        saturn_touched = 0;
        uranus_touched = 1;
    }
    else if(uranus_touched){
        uranus_touched = 0;
        neptune_touched = 1;
    }
    else if(neptune_touched){
        neptune_touched = 0;
        allow_tilt = true;
    }
    else{
        sun_touched = 1;
    }
}

-(void) planetInfoTapped:(UIButton *)button{
}

-(void) handlePinch:(UIPinchGestureRecognizer*)sender{
    if(sender.velocity >1 ){
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            zoom = zoom / 2;
        }
    }
    else if(sender.velocity < -1){
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            zoom = zoom * 2;
        }
    }
}

-(void) setTouched: (int) index{
    if(index == -1){
        touched_about_sun = 0;
        touched_about_self = 0;
        touched_dist_sun = 0;
        touched_height = 0;
        touched_width = 0;
        touched_spin = 0;
        touched_move = 0;
        self.planetInfo.hidden = YES;
    }
    if(index == 0) {
        touched_about_sun = 0;
        touched_about_self = sun_about_sun;
        touched_dist_sun = 0;
        touched_height = sun_height;
        touched_width = sun_width;
        touched_spin = sun_spin;
        touched_move = 0;
        allow_tilt = false;
        [self.planetInfo setTitle:@"The Sun" forState:UIControlStateNormal];
        self.planetInfo.hidden = NO;
    }
    if(index == 1) {
        touched_about_sun = mercury_about_sun;
        touched_about_self = mercury_about_mercury;
        touched_dist_sun = mercury_dist_sun;
        touched_height = mercury_height;
        touched_width = mercury_width;
        touched_spin = mercury_spin;
        touched_move = mercury_move;
        allow_tilt = false;
        [self.planetInfo setTitle:@"Mercury" forState:UIControlStateNormal];
        self.planetInfo.hidden = NO;
    }
    if(index == 2) {
        touched_about_sun = venus_about_sun;
        touched_about_self = venus_about_venus;
        touched_dist_sun = venus_dist_sun;
        touched_height = venus_height;
        touched_width = venus_width;
        touched_spin = venus_spin;
        touched_move = venus_move;
        allow_tilt = false;
        [self.planetInfo setTitle:@"Venus" forState:UIControlStateNormal];
        self.planetInfo.hidden = NO;
    }
    if(index == 3) {
        touched_about_sun = earth_about_sun;
        touched_about_self = earth_about_earth;
        touched_dist_sun = earth_dist_sun;
        touched_height = earth_height;
        touched_width = earth_width;
        touched_spin = earth_spin;
        touched_move = earth_move;
        allow_tilt = false;
        [self.planetInfo setTitle:@"Earth" forState:UIControlStateNormal];
        self.planetInfo.hidden = NO;
    }
    if(index == 4) {
        touched_about_sun = mars_about_sun;
        touched_about_self = mars_about_mars;
        touched_dist_sun = mars_dist_sun;
        touched_height = mars_height;
        touched_width = mars_width;
        touched_spin = mars_spin;
        touched_move = mars_move;
        allow_tilt = false;
        [self.planetInfo setTitle:@"Mars" forState:UIControlStateNormal];
        self.planetInfo.hidden = NO;
    }
    if(index == 5) {
        touched_about_sun = jupiter_about_sun;
        touched_about_self = jupiter_about_jupiter;
        touched_dist_sun = jupiter_dist_sun;
        touched_height = jupiter_height;
        touched_width = jupiter_width;
        touched_spin = jupiter_spin;
        touched_move = jupiter_move;
        allow_tilt = false;
        [self.planetInfo setTitle:@"Jupiter" forState:UIControlStateNormal];
        self.planetInfo.hidden = NO;
    }
    if(index == 6) {
        touched_about_sun = saturn_about_sun;
        touched_about_self = saturn_about_saturn;
        touched_dist_sun = saturn_dist_sun;
        touched_height = saturn_height;
        touched_width = saturn_width;
        touched_spin = saturn_spin;
        touched_move = saturn_move;
        allow_tilt = false;
        [self.planetInfo setTitle:@"Saturn" forState:UIControlStateNormal];
        self.planetInfo.hidden = NO;
    }
    if(index == 7) {
        touched_about_sun = uranus_about_sun;
        touched_about_self = uranus_about_uranus;
        touched_dist_sun = uranus_dist_sun;
        touched_height = uranus_height;
        touched_width = uranus_width;
        touched_spin = uranus_spin;
        touched_move = uranus_move;
        allow_tilt = false;
        [self.planetInfo setTitle:@"Uranus" forState:UIControlStateNormal];
        self.planetInfo.hidden = NO;
    }
    if(index == 8) {
        touched_about_sun = neptune_about_sun;
        touched_about_self = neptune_about_neptune;
        touched_dist_sun = neptune_dist_sun;
        touched_height = neptune_height;
        touched_width = neptune_width;
        touched_spin = neptune_spin;
        touched_move = neptune_move;
        allow_tilt = false;
        [self.planetInfo setTitle:@"Neptune" forState:UIControlStateNormal];
        self.planetInfo.hidden = NO;
    }
}

-(void) focusedDraw {
    glRotatef(-touched_about_self, 0, 0, 1);
    glTranslatef(-touched_dist_sun, 0, 0);
    glRotatef(-touched_about_sun, 0, 0, 1);
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _avgX = _avgY = _avgZ = 0.0;
        _varX = _varY = _varZ = 0.0;
        self.myView = (CMDisplayView *)self.view;
        
        self.motman = [CMMotionManager new];
        if ((self.motman.accelerometerAvailable)&&(self.motman.gyroAvailable))

        {
            [self startMonitoringMotion];
        }
        else
            NSLog(@"Oh well, accelerometer or gyro unavailable...");
    }
    return self;
}


#pragma mark - service methods
- (void)startMonitoringMotion
{
    self.motman.accelerometerUpdateInterval = 1.0/kMOTIONUPDATEINTERVAL;
    self.motman.showsDeviceMovementDisplay = YES;
    [self.motman startAccelerometerUpdates];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.motman.accelerometerUpdateInterval
                                                  target:self selector:@selector(pollMotion:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopMonitoringMotion
{
    [self.motman stopAccelerometerUpdates];
}

#pragma mark - UI event handlers

- (void)pollMotion:(NSTimer *)timer
{
    CMAcceleration acc = self.motman.accelerometerData.acceleration;
    float x, y, z;
    [self addAcceleration:acc];
    x = acc.x;
    y = acc.y;
    z = acc.z;
    [self refreshUIforCMDataWithX:x y:y z:z];
}

#pragma mark - helpers
- (void)addAcceleration:(CMAcceleration)acc
{
    float alpha = 0.1;
    _avgX = alpha*acc.x + (1-alpha)*_avgX;
    _avgY = alpha*acc.y + (1-alpha)*_avgY;
    _avgZ = alpha*acc.z + (1-alpha)*_avgZ;
    _varX = acc.x - _avgX;
    _varY = acc.y - _avgY;
    _varZ = acc.z - _avgZ;
}


- (void)refreshUIforCMDataWithX:(CGFloat)x
                              y:(CGFloat)y
                              z:(CGFloat)z
{
    _accX = x;
    _accY = y;
    _accZ = z;
    ytilt = _accY;
    xtilt = _accX;
    [self.view setNeedsDisplay];
}

@end

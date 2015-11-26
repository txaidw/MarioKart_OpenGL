//
//  GameViewController.m
//  MarioKart
//
//  Created by Txai Wieser on 22/11/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "JSAnalogueStick.h"
#import "JSButton.h"
#import "GameScene.h"
#import "TWGLShadersReference.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface GameViewController () <JSAnalogueStickDelegate, JSButtonDelegate>

@property (strong, nonatomic) TWGLShadersReference *shaders;
@property (strong, nonatomic) GameScene *scene;


@property (weak, nonatomic) IBOutlet JSAnalogueStick *analogueController;
@property (weak, nonatomic) IBOutlet JSButton *aButton;
@property (weak, nonatomic) IBOutlet JSButton *bButton;

@end

@implementation GameViewController



- (void)setupScene {
    _shaders = [[TWGLShadersReference alloc] initWithVertexShader:@"Shader.vsh" fragmentShader:@"Shader.fsh"];
    _scene = [[GameScene alloc] initWithShader:_shaders];
    _shaders.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    [EAGLContext setCurrentContext:view.context];
    
    [self setupScene];
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    glEnable(GL_DEPTH_TEST);
//    glEnable(GL_CULL_FACE);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    [self.scene render];
}

- (void)update {
    [self.scene updateWithDelta:self.timeSinceLastUpdate];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.analogueController.delegate = self;
    self.aButton.delegate = self;
    self.bButton.delegate = self;
}

#pragma mark - GLKView and GLKViewController delegate methods

#pragma mark - Controllers delegate methods

- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick
{
    self.scene.carNode.acceleration = analogueStick.yValue;
    self.scene.carNode.direction = analogueStick.xValue;
}

- (void)buttonPressed:(JSButton *)button
{
    if (button == self.aButton) {
        
    } else if (button == self.bButton) {
        
    }
}

- (void)buttonReleased:(JSButton *)button
{
    if (button == self.aButton) {
        
    } else if (button == self.bButton) {
        
    }
}



@end

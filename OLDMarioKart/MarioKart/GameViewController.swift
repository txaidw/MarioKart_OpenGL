//
//  GameViewController.swift
//  MarioKart
//
//  Created by Txai Wieser on 10/28/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import GLKit
import OpenGLES

class GameViewController: GLKViewController, JSAnalogueStickDelegate, JSButtonDelegate {
    
    @IBOutlet weak var analogueController: JSAnalogueStick! {
        didSet {
            analogueController.delegate = self
        }
    }
    @IBOutlet weak var aButton: JSButton! {
        didSet {
            aButton.delegate = self
        }
    }
    @IBOutlet weak var bButton: JSButton! {
        didSet {
            bButton.delegate = self
        }
    }
    
    func analogueStickDidChangeValue(analogueStick: JSAnalogueStick!) {
        scene.carNode.acceleration = Float(analogueStick.yValue)
        scene.carNode.direction = Float(analogueStick.xValue)
    }
    
    func buttonPressed(button: JSButton!) {
        if button === aButton {
            
        } else if button === bButton {
            
        }
    }
    
    func buttonReleased(button: JSButton!) {
        if button === aButton {
            
        } else if button === bButton {
            
        }
    }
    
    lazy var shader:TWGLShaderReference = {
        let s = TWGLShaderReference(vertexShader: "Shader.vsh", fragmentShader: "Shader.fsh")
        s.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), Float(self.view.bounds.size.width / self.view.bounds.size.height), 1, 150)
        return s
    }()
    
    lazy var scene:GameScene = {
       let s = GameScene(shader: self.shader)
        return s
    }()
    
    var context: EAGLContext? = nil
    
    deinit {
        if EAGLContext.currentContext() === self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.context = EAGLContext(API: .OpenGLES3)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .Format24
        
        EAGLContext.setCurrentContext(self.context)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded() && (self.view.window != nil) {
            self.view = nil
            
            if EAGLContext.currentContext() === self.context {
                EAGLContext.setCurrentContext(nil)
            }
            self.context = nil
        }
    }
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        glEnable(GLenum(GL_DEPTH_TEST))
        glEnable(GLenum(GL_CULL_FACE))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA));
        
        scene.render()
    }
    
    func update() {
        scene.update(timeSinceLastUpdate)
    }
}
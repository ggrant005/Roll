//
//  GameScene.swift
//  Roll
//
//  Created by Greg Grant on 1/7/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var entities = [GKEntity]()
  var graphs = [String : GKGraph]()

  private var lastUpdateTime : TimeInterval = 0
  
  private var circleNode : SKShapeNode!
  private var lineNode : SKShapeNode!
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func sceneDidLoad() {

    self.lastUpdateTime = 0
    
    // create physics world
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    physicsWorld.contactDelegate = self
    
    createSceneContents()
    createCircle()
    createLine()
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchDown(atPoint pos : CGPoint) {
    self.childNode(withName: "circle")?.removeFromParent()
    self.circleNode.position = pos
    self.addChild(self.circleNode)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchMoved(toPoint pos : CGPoint) {
    self.childNode(withName: "circle")?.removeFromParent()
    self.circleNode.position = pos
    self.addChild(self.circleNode)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchUp(atPoint pos : CGPoint) {
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
      
    // Initialize _lastUpdateTime if it has not already been
    if (self.lastUpdateTime == 0) {
      self.lastUpdateTime = currentTime
    }
      
    // Calculate time since last update
    let dt = currentTime - self.lastUpdateTime
      
    // Update entities
    for entity in self.entities {
      entity.update(deltaTime: dt)
    }
      
    self.lastUpdateTime = currentTime
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createSceneContents() {
    self.backgroundColor = .black
    self.scaleMode = .aspectFit
    self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createCircle() {
    let w = (self.size.width + self.size.height) * 0.01
    self.circleNode = SKShapeNode.init(circleOfRadius: CGFloat(w))
    self.circleNode.name = "circle"
    self.circleNode.lineWidth = 2.5
    self.circleNode.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w))
    self.circleNode.physicsBody?.restitution = 0.75
    self.circleNode.physicsBody?.isDynamic = true
    self.circleNode.physicsBody?.collisionBitMask = 0b0001
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createLine() {
    var points = [CGPoint(x: -200, y: 200),
                  CGPoint(x: -100, y: 25),
                  CGPoint(x: 100, y: 25),
                  CGPoint(x: 200, y: 200)]
    
    self.lineNode = SKShapeNode.init(splinePoints: &points, count: points.count)
    self.lineNode.name = "line"
    self.lineNode.lineWidth = 2.5
    self.lineNode.physicsBody = SKPhysicsBody(edgeChainFrom: lineNode.path!)
    self.lineNode.physicsBody?.restitution = 0.75
    self.lineNode.physicsBody?.isDynamic = false
    self.lineNode.physicsBody?.categoryBitMask = 0b0001
    
    self.addChild(self.lineNode)
  }
}

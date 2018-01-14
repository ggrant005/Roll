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
  
  private var ball : SKShapeNode!
  private var path : SKShapeNode!
  
  private var pathPoints : [CGPoint] = []
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func sceneDidLoad() {

    lastUpdateTime = 0
    
    // create physics world
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    physicsWorld.contactDelegate = self
    
    createSceneContents()
    createBall()
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchDown(atPoint pos : CGPoint) {
    pathPoints = []
    createPath(atPoint: pos)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchMoved(toPoint pos : CGPoint) {
    createPath(atPoint: pos)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchUp(atPoint pos : CGPoint) {
    createPath(atPoint: pos)
    ball?.physicsBody?.isDynamic = true // release ball
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { touchDown(atPoint: t.location(in: self)) }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { touchMoved(toPoint: t.location(in: self)) }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { touchUp(atPoint: t.location(in: self)) }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { touchUp(atPoint: t.location(in: self)) }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
      
    // Initialize _lastUpdateTime if it has not already been
    if (lastUpdateTime == 0) {
      lastUpdateTime = currentTime
    }
      
    // Calculate time since last update
    let dt = currentTime - lastUpdateTime
      
    // Update entities
    for entity in entities {
      entity.update(deltaTime: dt)
    }
    
    lastUpdateTime = currentTime
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createSceneContents() {
    backgroundColor = .black
    scaleMode = .aspectFit
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createBall() {
    let w = (size.width + size.height) * 0.01
    ball = SKShapeNode.init(circleOfRadius: CGFloat(w))
    ball.name = "ball"
    ball.lineWidth = 2.5
    ball.position = CGPoint(x: -200, y: 300)
    ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w))
    ball.physicsBody?.restitution = 0.75
    ball.physicsBody?.isDynamic = false
    ball.physicsBody?.collisionBitMask = 0b0001
    addChild(ball)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createPath(atPoint pos : CGPoint) {
    path?.removeFromParent()
    pathPoints.append(pos)
    path = SKShapeNode.init(
      splinePoints: &pathPoints,
      count: pathPoints.count)
    path.physicsBody = SKPhysicsBody(edgeChainFrom: path.path!)
    path.name = "path"
    path.lineWidth = 5
    path.physicsBody?.isDynamic = false
    path.physicsBody?.categoryBitMask = 0b0001
    addChild(path)
  }
}

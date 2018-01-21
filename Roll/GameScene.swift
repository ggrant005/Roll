//
//  GameScene.swift
//  Roll
//
//  Created by Greg Grant on 1/7/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameState {
  case new
  case playing
  case goal
}

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var entities = [GKEntity]()
  var graphs = [String : GKGraph]()

  var lastUpdateTime : TimeInterval = 0
  
  var ball : SKShapeNode!
  var path : SKShapeNode!
  var block : SKShapeNode!
  var goal : SKShapeNode!
  
  var pathPoints : [CGPoint] = []
  
  var doubleTapped = false
  
  let tapRec2 = UITapGestureRecognizer()
  
  var levelLabel: SKLabelNode!
  
  var gameState = GameState.new
  
  var level: Int = 1 {
    didSet {
      levelLabel.text = "\(level)"
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func sceneDidLoad() {
    
    lastUpdateTime = 0
    
    // create physics world
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    physicsWorld.contactDelegate = self
    
    createSceneContents()
    createLevelLabel()
    createBall()
    createBlock()
    createGoal()
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func didMove(to view: SKView) {
    self.view!.isMultipleTouchEnabled = false
    tapRec2.addTarget(self, action:#selector(GameScene.doubleTapped(_:) ))
    tapRec2.numberOfTapsRequired = 2
    self.view!.addGestureRecognizer(tapRec2)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchDown(atPoint pos : CGPoint) {
    gameState = .playing
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
    if doubleTapped {
      doubleTapped = false
    }
    else {
      createPath(atPoint: pos)
      ball?.physicsBody?.isDynamic = true // release ball
    }
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
  func didBegin(_ contact: SKPhysicsContact) {
    if gameState == .playing {
      if contact.bodyA.node == goal || contact.bodyB.node == goal {
        gameState = .goal
        goal.fillColor = .red
        
        // next level
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
          self.level += 1
          self.gameState = .new
          self.createBall()
          self.goal.fillColor = .black
          self.path?.removeFromParent()
        })
      }
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  @objc func doubleTapped(_ sender:UITapGestureRecognizer) {
    resetScene()
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func resetScene() {
    gameState = .new
    createBall()
    doubleTapped = true
    goal.fillColor = .black
    level = 1
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
  func createLevelLabel() {
    levelLabel = SKLabelNode(fontNamed: "Courier")
    levelLabel.text = "\(level)"
    levelLabel.horizontalAlignmentMode = .right
    levelLabel.position = CGPoint(x: size.width * 0.37, y: size.height * 0.46)
    print("\(size)")
    addChild(levelLabel)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createBall() {
    ball?.removeFromParent()
    let w = (size.width + size.height) * 0.01
    ball = SKShapeNode.init(circleOfRadius: CGFloat(w))
    ball.name = "ball"
    ball.lineWidth = 2.5
    ball.position = CGPoint(x: -200, y: 300)
    ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w))
    ball.physicsBody?.restitution = 0.75
    ball.physicsBody?.isDynamic = false
    ball.physicsBody?.contactTestBitMask = 0b0001
    addChild(ball)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createPath(atPoint pos : CGPoint) {
    path?.removeFromParent()
    pathPoints.append(pos)
    path = SKShapeNode.init(splinePoints: &pathPoints, count: pathPoints.count)
    path.name = "path"
    path.lineWidth = 2.5
    path.physicsBody = SKPhysicsBody(edgeChainFrom: path.path!)
    path.physicsBody?.isDynamic = false
    path.physicsBody?.contactTestBitMask = 0b0001
    addChild(path)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createBlock() {
    block?.removeFromParent()
    let w = (size.width + size.height) * 0.01
    let blockRect = CGRect(x: -w, y: -2 * w, width: 2 * w, height: 4 * w)
    block = SKShapeNode.init(rect: blockRect)
    block.name = "block"
    block.lineWidth = 2.5
    block.physicsBody = SKPhysicsBody(
      rectangleOf: blockRect.size,
      center: CGPoint(x: 0, y: 0))
    block.physicsBody?.isDynamic = false
    block.physicsBody?.contactTestBitMask = 0b0001
    addChild(block)
    
    loopBlockMovement(
      block: block,
      translation: 700,
      duration: 5)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func loopBlockMovement(
    block: SKShapeNode,
    translation: CGFloat,
    duration: TimeInterval) {
    
    let moveDown = SKAction.moveBy(
      x: 0,
      y: -translation / 2,
      duration: duration / 2)
    
    let moveUp = SKAction.moveBy(
      x: 0,
      y: translation,
      duration: duration)
    
    let moveLoop = SKAction.sequence([moveDown, moveUp, moveDown])
    let moveForever = SKAction.repeatForever(moveLoop)
    
    block.run(moveForever)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createGoal() {
    goal?.removeFromParent()
    let w = (size.width + size.height) * 0.01
    goal = SKShapeNode.init(circleOfRadius: CGFloat(w/2))
    goal.name = "goal"
    goal.strokeColor = .red
    goal.lineWidth = 2.5
    goal.position = CGPoint(x: 100, y: -350)
    goal.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w/2))
    goal.physicsBody?.isDynamic = false
    goal.physicsBody?.contactTestBitMask = 0b0001
    addChild(goal)
  }
}

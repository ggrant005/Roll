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
  
  var mObjects: [SKShapeNode] = []
  
  var mTripleTapped = false
  
  let mTapRec3 = UITapGestureRecognizer()
  
  var mGameState = GameState.eNew
  
  var mLevel = Level()
  var mLevelLabel: SKLabelNode!
  var mLevelNum = (1, 1) {
    didSet {
      mLevelLabel.text = "\(mLevelNum.0):\(mLevelNum.1)"
    }
  }
  
  //**
  override func sceneDidLoad() {
    // create physics world
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    physicsWorld.contactDelegate = self
    
    createSceneContents()
    createLevelLabel()
    setLevel(to: mLevelNum)
  }
  
  //**
  override func didMove(to view: SKView) {
    self.view!.isMultipleTouchEnabled = false
    
    mTapRec3.addTarget(self, action:#selector(GameScene.tripleTapped(_:) ))
    mTapRec3.numberOfTapsRequired = 3
    self.view!.addGestureRecognizer(mTapRec3)
  }
  
  //**
  func touchDown(atPoint pos: CGPoint) {
    if mGameState != .eGoal {
      mGameState = .ePlaying
      mLevel.mPathPoints = []
      createPath(atPoint: pos)
    }
  }
  
  //**
  func touchMoved(toPoint pos: CGPoint) {
    if mGameState != .eGoal {
      createPath(atPoint: pos)
    }
  }
  
  //**
  func touchUp(atPoint pos: CGPoint) {
    if mTripleTapped {
      mTripleTapped = false
    }
    else if mGameState != .eGoal {
      createPath(atPoint: pos)
      mLevel.mBall?.physicsBody?.isDynamic = true // release ball
    }
  }
  
  //**
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { touchDown(atPoint: t.location(in: self)) }
  }
  
  //**
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { touchMoved(toPoint: t.location(in: self)) }
  }
  
  //**
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { touchUp(atPoint: t.location(in: self)) }
  }
  
  //**
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { touchUp(atPoint: t.location(in: self)) }
  }
  
  //**
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    // auto reset when ball drops offscreen
    if mGameState == .ePlaying {
      if
        mLevel.mBall.position.x > 0.6 * size.width ||
        mLevel.mBall.position.x < -0.6 * size.width ||
        mLevel.mBall.position.y < -0.75 * size.height {
          resetLevel(to: mLevelNum)
      }
    }
  }
  
  //**
  func didBegin(_ contact: SKPhysicsContact) {
    if mGameState == .ePlaying {
      if contact.bodyA.node == mLevel.mGoal || contact.bodyB.node == mLevel.mGoal {
        hitGoal()
      }
    }
  }
  
  //**
  @objc func tripleTapped(_ sender:UITapGestureRecognizer) {
    if mGameState != .eGoal {
      mTripleTapped = true
      resetLevel(to: (1, 1))
    }
  }
  
  //**
  func createSceneContents() {
    backgroundColor = .black
    scaleMode = .aspectFit
  }
  
  //**
  func createLevelLabel() {
    mLevelLabel = SKLabelNode(fontNamed: "Courier")
    mLevelLabel.text = "\(mLevelNum)"
    mLevelLabel.horizontalAlignmentMode = .right
    mLevelLabel.position = CGPoint(x: size.width * 0.37, y: size.height * 0.46)
    addChild(mLevelLabel)
  }
  
  //**
  func createObjects() {
    createBall(with: size)
    createBlocks(with: size)
    createGoal(with: size)
  }
  
  //**
  func destroyObjects() {
    for object in mObjects {
      object.removeFromParent()
    }
  }
  
  //**
  func nextLevel() {
    if mLevelNum.1 % 5 == 0 {
      mLevelNum.0 += 1 // increment set
      mLevelNum.1 = 1 // level 1
    }
    else {
      mLevelNum.1 += 1 // increment level
    }
    
    resetLevel(to: mLevelNum)
  }
  
  //**
  func setLevel(to levelNum: (Int, Int)) {
    mGameState = .eNew
    mLevelNum = levelNum // set label
    mLevel = getLevel(levelNum)
    createObjects()
  }
  
  //**
  func resetLevel(to level: (Int, Int)) {
    destroyObjects()
    setLevel(to: level)
  }
  
  //**
  func hitGoal() {
    mGameState = .eGoal
    mLevel.mGoal.removeFromParent()
    mLevel.mPath.removeFromParent()
    
    throwSparks(with: 100)
    
    // next level
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
      self.nextLevel()
    })
  }
  
  //**
  func addObject(_ shapeNode: SKShapeNode) {
    mObjects.append(shapeNode)
    addChild(shapeNode)
  }
  
  //**
  func createBall(with size: CGSize) {
    mLevel.createBall(with: size)
    addObject(mLevel.mBall)
  }
  
  //**
  func createBlocks(with size: CGSize) {
    mLevel.createBlocks(with: size)
    for block in mLevel.mBlocks { addObject(block) }
  }
  
  //**
  func createGoal(with size: CGSize) {
    mLevel.createGoal(with: size)
    addObject(mLevel.mGoal)
  }
  
  //**
  func createPath(atPoint pos: CGPoint) {
    mLevel.mPath?.removeFromParent()
    mLevel.createPath(atPoint: pos)
    addObject(mLevel.mPath)
  }
  
  //**
  func throwSparks(with numSparks: Int) {
    let radius = CGFloat(1)
    for _ in 0 ..< numSparks {
      let spark = SKShapeNode(circleOfRadius: radius)
      spark.name = "spark"
      spark.lineWidth = 2.5
      spark.position = mLevel.mGoal.position
      spark.physicsBody = SKPhysicsBody(circleOfRadius: radius)
      addObject(spark)
      
      let impulse = CGVector(
        dx: 0.05 * (2.0 * drand48() - 1.0),
        dy: 0.05 * (2.0 * drand48() - 1.0))
      spark.physicsBody?.applyImpulse(impulse)
    }
  }
}

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
  case mNew
  case mPlaying
  case mGoal
}

struct ObjectMotion {
  var mHasMotion: Bool
  var mBoundingBox: CGRect
  var mVelocity: CGVector
  var mAcceleration: CGVector
}

struct Object {
  var mStartPosition: CGPoint
  var mMotion: ObjectMotion
}

struct LevelContents {
  let mLevel: Int
  var mNumBlocks: Int
  var mBall: Object
  var mObstacles: [Object]
  var mGoals: [Object]
}

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var mEntities = [GKEntity]()
  var mGraphs = [String : GKGraph]()
  
  var mLastUpdateTime : TimeInterval = 0
  
  var mBall : SKShapeNode!
  var mPath : SKShapeNode!
  var mBlock : SKShapeNode!
  var mGoal : SKShapeNode!
  
  var mPathPoints : [CGPoint] = []
  
  var mDoubleTapped = false
  
  let mTapRec2 = UITapGestureRecognizer()
  let mTapRec3 = UITapGestureRecognizer()
  
  var mLevelLabel: SKLabelNode!
  
  var mGameState = GameState.mNew
  
  var mLevel: Int = 1 {
    didSet {
      mLevelLabel.text = "\(mLevel)"
    }
  }
  
  var mLevels = [LevelContents]()
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func sceneDidLoad() {
    
    mLastUpdateTime = 0
    
    // create physics world
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    physicsWorld.contactDelegate = self
    
    createSceneContents()
    createLevelLabel()
    createGame()
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func didMove(to view: SKView) {
    self.view!.isMultipleTouchEnabled = false
    
    mTapRec2.addTarget(self, action:#selector(GameScene.doubleTapped(_:) ))
    mTapRec2.numberOfTapsRequired = 2
    self.view!.addGestureRecognizer(mTapRec2)
    
    mTapRec3.addTarget(self, action:#selector(GameScene.tripleTapped(_:) ))
    mTapRec3.numberOfTapsRequired = 3
    self.view!.addGestureRecognizer(mTapRec3)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchDown(atPoint pos : CGPoint) {
    mGameState = .mPlaying
    mPathPoints = []
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
    if mDoubleTapped {
      mDoubleTapped = false
    }
    else {
      createPath(atPoint: pos)
      mBall?.physicsBody?.isDynamic = true // release ball
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
    if (mLastUpdateTime == 0) {
      mLastUpdateTime = currentTime
    }
      
    // Calculate time since last update
//    let dt = currentTime - mLastUpdateTime
    
    mLastUpdateTime = currentTime
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func didBegin(_ contact: SKPhysicsContact) {
    if mGameState == .mPlaying {
      if contact.bodyA.node == mGoal || contact.bodyB.node == mGoal {
        mGameState = .mGoal
        mGoal.fillColor = .red
        
        // next level
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
          self.resetGame(toLevel: self.mLevel + 1)
        })
      }
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  @objc func doubleTapped(_ sender:UITapGestureRecognizer) {
    resetGame(toLevel: mLevel)
    mDoubleTapped = true
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  @objc func tripleTapped(_ sender:UITapGestureRecognizer) {
    resetGame(toLevel: 1)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createGame() {
    mGameState = .mNew
    createBall(atLevel: mLevel)
    createBlock(atLevel: mLevel)
    createGoal(atLevel: mLevel)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func resetGame(toLevel level: Int) {
    mGameState = .mNew
    mPath?.removeFromParent()
    createBall(atLevel: mLevel)
    
    // so block will keep moving how it was
    if mLevel != level {
      createBlock(atLevel: mLevel)
    }
    
    createGoal(atLevel: mLevel)
    mGoal.fillColor = .black
    mLevel = level
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
    mLevelLabel = SKLabelNode(fontNamed: "Courier")
    mLevelLabel.text = "\(mLevel)"
    mLevelLabel.horizontalAlignmentMode = .right
    mLevelLabel.position = CGPoint(x: size.width * 0.37, y: size.height * 0.46)
    print("\(size)")
    addChild(mLevelLabel)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createBall(atLevel level: Int) {
    mBall?.removeFromParent()
    let w = (size.width + size.height) * 0.01
    mBall = SKShapeNode.init(circleOfRadius: CGFloat(w))
    mBall.name = "ball"
    mBall.lineWidth = 2.5
    mBall.position = CGPoint(x: -200, y: 300)
    mBall.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w))
    mBall.physicsBody?.restitution = 0.75
    mBall.physicsBody?.isDynamic = false
    mBall.physicsBody?.contactTestBitMask = 0b0001
    addChild(mBall)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createPath(atPoint pos : CGPoint) {
    mPath?.removeFromParent()
    mPathPoints.append(pos)
    mPath = SKShapeNode.init(
      splinePoints: &mPathPoints,
      count: mPathPoints.count)
    mPath.name = "path"
    mPath.lineWidth = 2.5
    mPath.physicsBody = SKPhysicsBody(edgeChainFrom: mPath.path!)
    mPath.physicsBody?.isDynamic = false
    mPath.physicsBody?.contactTestBitMask = 0b0001
    addChild(mPath)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createBlock(atLevel level: Int) {
    mBlock?.removeFromParent()
    let w = (size.width + size.height) * 0.01
    let blockRect = CGRect(x: -w, y: -2 * w, width: 2 * w, height: 4 * w)
    mBlock = SKShapeNode.init(rect: blockRect)
    mBlock.name = "block"
    mBlock.lineWidth = 2.5
    mBlock.physicsBody = SKPhysicsBody(
      rectangleOf: blockRect.size,
      center: CGPoint(x: 0, y: 0))
    mBlock.physicsBody?.isDynamic = false
    mBlock.physicsBody?.contactTestBitMask = 0b0001
    addChild(mBlock)
    
    loopBlockMovement(
      block: mBlock,
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
  func createGoal(atLevel level: Int) {
    mGoal?.removeFromParent()
    let w = (size.width + size.height) * 0.01
    mGoal = SKShapeNode.init(circleOfRadius: CGFloat(w/2))
    mGoal.name = "goal"
    mGoal.strokeColor = .red
    mGoal.lineWidth = 2.5
    mGoal.position = CGPoint(x: 100, y: -350)
    mGoal.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w/2))
    mGoal.physicsBody?.isDynamic = false
    mGoal.physicsBody?.contactTestBitMask = 0b0001
    addChild(mGoal)
  }
}

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
  var mSparks : [SKShapeNode] = []
  var mDeleteTheseObjects : [SKShapeNode] = []
  
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
  
  let mNumSparks = 32
  
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
    
    // ball offscreen
    if (mBall.position.y < -2 * size.height) {
      resetLevel()
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func didBegin(_ contact: SKPhysicsContact) {
    if mGameState == .mPlaying {
      if contact.bodyA.node == mGoal || contact.bodyB.node == mGoal {
        hitGoal()
      }
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  @objc func doubleTapped(_ sender:UITapGestureRecognizer) {
    resetLevel()
    mDoubleTapped = true
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  @objc func tripleTapped(_ sender:UITapGestureRecognizer) {
    resetGame()
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createSceneContents() {
    backgroundColor = .black
    scaleMode = .aspectFit
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createLevelLabel() {
    mLevelLabel = SKLabelNode(fontNamed: "Courier")
    mLevelLabel.text = "\(mLevel)"
    mLevelLabel.horizontalAlignmentMode = .right
    mLevelLabel.position = CGPoint(x: size.width * 0.37, y: size.height * 0.46)
    addChild(mLevelLabel)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createObjects(atLevel level: Int) {
    createBall(atLevel: level)
    createBlock(atLevel: level)
    createGoal(atLevel: level)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func destroyObjects() {
    for object in mDeleteTheseObjects {
      object.removeFromParent()
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createGame() {
    mGameState = .mNew
    
    createObjects(atLevel: 1)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func setLevel(to level: Int) {
    mGameState = .mNew
    mGoal.fillColor = .black
    mPath?.removeFromParent()
    mLevel = level // set label
    
    createObjects(atLevel: level)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func nextLevel() {
    mLevel += 1
    destroyObjects()
    setLevel(to: mLevel)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func resetLevel() {
    destroyObjects()
    setLevel(to: mLevel)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func resetGame() {
    destroyObjects()
    setLevel(to: 1)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func hitGoal() {
    mGameState = .mGoal
    mGoal.removeFromParent()
    mPath.removeFromParent()
    
    throwSparks()
    
    // next level
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
      self.nextLevel()
    })
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
    
    mDeleteTheseObjects.append(mPath)
    addChild(mPath)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createBall(atLevel level: Int) {
    let w = (size.width + size.height) * 0.01
    mBall = SKShapeNode.init(circleOfRadius: CGFloat(w))
    mBall.name = "ball"
    mBall.lineWidth = 2.5
    mBall.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w))
    mBall.physicsBody?.restitution = 0.75
    mBall.physicsBody?.isDynamic = false
    mBall.physicsBody?.contactTestBitMask = 0b0001
    
    switch level {
    case 1:
      mBall.position = CGPoint(x: -200, y: 300)
    case 2:
      mBall.position = CGPoint(x: 0, y: 50)
      mBall.physicsBody?.isDynamic = true
    default:
      mBall.position = CGPoint(x: 50, y: -400)
    }
    
    mDeleteTheseObjects.append(mBall)
    addChild(mBall)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createBlock(atLevel level: Int) {
    let w = (size.width + size.height) * 0.01
    let blockSize = CGSize(width: 2 * w, height: 4 * w)
    mBlock = SKShapeNode.init(rectOf: blockSize)
    mBlock.name = "block"
    mBlock.lineWidth = 2.5
    mBlock.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
    mBlock.physicsBody?.isDynamic = false
    mBlock.physicsBody?.contactTestBitMask = 0b0001
    
    var xTranslation = CGFloat(0)
    var yTranslation = CGFloat(0)
    var duration = TimeInterval(5)
    switch level {
    case 1:
      mBlock.position = CGPoint(x: 0, y: 0)
      xTranslation = CGFloat(0)
      yTranslation = CGFloat(700)
      duration = TimeInterval(5)
    case 2:
      mBlock.position = CGPoint(x: 0, y: 0)
      xTranslation = CGFloat(0)
      yTranslation = CGFloat(700)
      duration = TimeInterval(5)
    default:
      mBlock.position = CGPoint(x: 50, y: -300)
      xTranslation = CGFloat(0)
      yTranslation = CGFloat(100)
      duration = TimeInterval(0.1)
    }
    
    loopBlockMovement(
      block: mBlock,
      xTranslation: xTranslation,
      yTranslation: yTranslation,
      duration: duration)
    
    mDeleteTheseObjects.append(mBlock)
    addChild(mBlock)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createGoal(atLevel level: Int) {
    let w = (size.width + size.height) * 0.01
    mGoal = SKShapeNode.init(circleOfRadius: CGFloat(w/2))
    mGoal.name = "goal"
    mGoal.strokeColor = .red
    mGoal.lineWidth = 2.5
    mGoal.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w/2))
    mBall.physicsBody?.restitution = 0.75
    mGoal.physicsBody?.isDynamic = false
    mGoal.physicsBody?.contactTestBitMask = 0b0001
    
    switch level {
    case 1:
      mGoal.position = CGPoint(x: 100, y: -350)
    case 2:
      mGoal.position = CGPoint(x: 0, y: -350)
    default:
      mGoal.position = CGPoint(x: 100, y: -350)
    }
    
    mDeleteTheseObjects.append(mGoal)
    addChild(mGoal)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func throwSparks() {
    let angleRad = 2 * .pi / Double(mNumSparks)
    let radius = CGFloat(1)
    for i in 0 ..< mNumSparks {
      mSparks.append(SKShapeNode(circleOfRadius: radius))
      mSparks[i].name = "spark"
      mSparks[i].lineWidth = 2.5
      mSparks[i].position = mGoal.position
      mSparks[i].physicsBody = SKPhysicsBody(circleOfRadius: radius)
      
      mDeleteTheseObjects.append(mSparks[i])
      addChild(mSparks[i])
      
      let angle = Double(i) * angleRad
      let impulse = CGVector(dx: 0.02 * cos(angle), dy: 0.02 * sin(angle))
      mSparks[i].physicsBody?.applyImpulse(impulse)
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func loopBlockMovement(
    block: SKShapeNode,
    xTranslation: CGFloat,
    yTranslation: CGFloat,
    duration: TimeInterval) {
    
    let firstMove = SKAction.moveBy(
      x: -xTranslation / 2,
      y: -yTranslation / 2,
      duration: duration / 2)
    
    let secondMove = SKAction.moveBy(
      x: xTranslation,
      y: yTranslation,
      duration: duration)
    
    let moveLoop = SKAction.sequence([firstMove, secondMove, firstMove])
    let moveForever = SKAction.repeatForever(moveLoop)
    
    block.run(moveForever)
  }
}

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
  
  var mPath : SKShapeNode!
  var mBlock : SKShapeNode!
  var mGoal : SKShapeNode!
  var mSparks : [SKShapeNode] = []
  var mDeleteTheseObjects : [SKShapeNode] = []
  
  var mPathPoints : [CGPoint] = []
  
  var mTripleTapped = false
  
  let mTapRec3 = UITapGestureRecognizer()
  
  var mGameState = GameState.mNew
  
  var mLevel = Level()
  var mLevelLabel: SKLabelNode!
  var mLevelNum: Int = 1 {
    didSet {
      mLevelLabel.text = "\(mLevelNum)"
    }
  }
  
  let mNumSparks = 128
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func sceneDidLoad() {
    // create physics world
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
    physicsWorld.contactDelegate = self
    
    createSceneContents()
    createLevelLabel()
    setLevel(to: mLevelNum)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  override func didMove(to view: SKView) {
    self.view!.isMultipleTouchEnabled = false
    
    mTapRec3.addTarget(self, action:#selector(GameScene.tripleTapped(_:) ))
    mTapRec3.numberOfTapsRequired = 3
    self.view!.addGestureRecognizer(mTapRec3)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchDown(atPoint pos : CGPoint) {
    if mGameState != .mGoal {
      mGameState = .mPlaying
      mPathPoints = []
      createPath(atPoint: pos)
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchMoved(toPoint pos : CGPoint) {
    if mGameState != .mGoal {
      createPath(atPoint: pos)
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func touchUp(atPoint pos : CGPoint) {
    if mTripleTapped {
      mTripleTapped = false
    }
    else {
      if mGameState != .mGoal {
        createPath(atPoint: pos)
        mLevel.mBall?.physicsBody?.isDynamic = true // release ball
      }
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
    
    // auto reset when ball drops offscreen
    if mGameState == .mPlaying {
      if
        mLevel.mBall.position.x > 0.6 * size.width ||
        mLevel.mBall.position.x < -0.6 * size.width ||
        mLevel.mBall.position.y < -0.75 * size.height {
          resetLevel()
      }
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
  @objc func tripleTapped(_ sender:UITapGestureRecognizer) {
    if mGameState != .mGoal {
      mTripleTapped = true
      resetGame()
    }
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
    mLevelLabel.text = "\(mLevelNum)"
    mLevelLabel.horizontalAlignmentMode = .right
    mLevelLabel.position = CGPoint(x: size.width * 0.37, y: size.height * 0.46)
    addChild(mLevelLabel)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createObjects(atLevel level: Int) {
    createBall()
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
  func setLevel(to levelNum: Int) {
    mGameState = .mNew
    mGoal?.fillColor = .black
    mPath?.removeFromParent()
    mLevelNum = levelNum // set label
    
    switch levelNum {
    case 1:
      mLevel = Level1()
    case 2:
      mLevel = Level2()
    case 3:
      mLevel = Level3()
    case 4:
      mLevel = Level4()
    default:
      mLevel = Level1()
    }
    
    createObjects(atLevel: levelNum)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func nextLevel() {
    mLevelNum += 1
    destroyObjects()
    setLevel(to: mLevelNum)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func resetLevel() {
    destroyObjects()
    setLevel(to: mLevelNum)
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
  func createBall() {
    mLevel.createBall(size: size)
    mDeleteTheseObjects.append(mLevel.mBall)
    addChild(mLevel.mBall)
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
    
    mBlock.position = mLevel.mLevelOptions.mBlockOptions.mStartPosition
    
    switch mLevel.mLevelOptions.mBlockOptions.mMovement {
    case .mRotate(let angle, let duration):
      BlockMovement.loopRotate(
        shapeNode: mBlock,
        byAngle: angle,
        duration: duration)
    case .mSpin(let duration):
      BlockMovement.loopSpin(
        shapeNode: mBlock,
        duration: duration)
    case .mTranslate(let xTrans, let yTrans, let duration):
      BlockMovement.loopTranslate(
        shapeNode: mBlock,
        xTranslation: xTrans,
        yTranslation: yTrans,
        duration: duration)
    }
    
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
    mGoal.physicsBody?.restitution = 0.75
    mGoal.physicsBody?.isDynamic = false
    mGoal.physicsBody?.contactTestBitMask = 0b0001
    
    mGoal.position = mLevel.mLevelOptions.mGoalOptions.mStartPosition
    
    mDeleteTheseObjects.append(mGoal)
    addChild(mGoal)
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func throwSparks() {
    let radius = CGFloat(1)
    for i in 0 ..< mNumSparks {
      mSparks.append(SKShapeNode(circleOfRadius: radius))
      mSparks[i].name = "spark"
      mSparks[i].lineWidth = 2.5
      mSparks[i].position = mGoal.position
      mSparks[i].physicsBody = SKPhysicsBody(circleOfRadius: radius)
      
      mDeleteTheseObjects.append(mSparks[i])
      addChild(mSparks[i])
      
      let impulse = CGVector(
        dx: 0.03 * (2.0 * drand48() - 1.0),
        dy: 0.03 * (2.0 * drand48() - 1.0))
      mSparks[i].physicsBody?.applyImpulse(impulse)
    }
  }
}

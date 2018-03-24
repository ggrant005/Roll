//
//  Level.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

class Level {
  var mLevelOptions = LevelOptions()
  
  var mBall : SKShapeNode!
  var mBlock : SKShapeNode!
  var mGoal : SKShapeNode!
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createBall(size: CGSize) {
    let w = (size.width + size.height) * 0.01
    mBall = SKShapeNode.init(circleOfRadius: CGFloat(w))
    mBall.name = "ball"
    mBall.lineWidth = 2.5
    mBall.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w))
    mBall.physicsBody?.restitution = 0.75
    mBall.physicsBody?.isDynamic = false
    mBall.physicsBody?.contactTestBitMask = 0b0001
    
    mBall.position = mLevelOptions.mBallOptions.mStartPosition
    mBall.physicsBody?.isDynamic = mLevelOptions.mBallOptions.mIsDynamic
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createBlock(size: CGSize) {
    let w = (size.width + size.height) * 0.01
    let blockSize = CGSize(width: 2 * w, height: 4 * w)
    mBlock = SKShapeNode.init(rectOf: blockSize)
    mBlock.name = "block"
    mBlock.lineWidth = 2.5
    mBlock.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
    mBlock.physicsBody?.isDynamic = false
    mBlock.physicsBody?.contactTestBitMask = 0b0001
    
    mBlock.position = mLevelOptions.mBlockOptions.mStartPosition
    
    switch mLevelOptions.mBlockOptions.mMovement {
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
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  func createGoal(size: CGSize) {
    let w = (size.width + size.height) * 0.01
    mGoal = SKShapeNode.init(circleOfRadius: CGFloat(w/2))
    mGoal.name = "goal"
    mGoal.strokeColor = .red
    mGoal.lineWidth = 2.5
    mGoal.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w/2))
    mGoal.physicsBody?.restitution = 0.75
    mGoal.physicsBody?.isDynamic = false
    mGoal.physicsBody?.contactTestBitMask = 0b0001
    
    mGoal.position = mLevelOptions.mGoalOptions.mStartPosition
  }
}

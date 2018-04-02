//
//  Level.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

class Level {
  var mBallOptions = BallOptions()
  var mBlockOptions : [BlockOptions] = []
  var mGoalOptions = GoalOptions()
  
  var mBall : SKShapeNode!
  var mBlocks : [SKShapeNode] = []
  var mGoal : SKShapeNode!
  var mPath : SKShapeNode!
  
  var mPathPoints : [CGPoint] = []
  
  //**
  func createBall(with size: CGSize) {
    let w = (size.width + size.height) * 0.01
    mBall = SKShapeNode.init(circleOfRadius: CGFloat(w))
    mBall.name = "ball"
    mBall.lineWidth = 2.5
    mBall.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w))
    mBall.physicsBody?.restitution = 0.75
    mBall.physicsBody?.isDynamic = false
    mBall.physicsBody?.contactTestBitMask = 0b0001
    
    mBall.position = mBallOptions.mStartPosition
    mBall.physicsBody?.isDynamic = mBallOptions.mIsDynamic
  }
  
  //**
  func createBlock(with size: CGSize) {
    let w = (size.width + size.height) * 0.01
    let blockSize = CGSize(width: 2 * w, height: 4 * w)
    
    for options in mBlockOptions {
      let block = SKShapeNode.init(rectOf: blockSize)
      block.name = "block"
      block.lineWidth = 2.5
      block.position = options.mStartPosition
      block.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
      block.physicsBody?.isDynamic = false
      block.physicsBody?.contactTestBitMask = 0b0001
      
      switch options.mMovement {
      case .eSeesaw(let direction, let angle, let duration):
        BlockMovement.seesaw(
          shapeNode: block,
          direction: direction,
          byAngle: angle,
          duration: duration)
      case .eSlide(let direction, let distance, let duration):
        BlockMovement.slide(
          shapeNode: block,
          direction: direction,
          distance: distance,
          duration: duration)
      case .eSpin(let direction, let duration):
        BlockMovement.spin(
          shapeNode: block,
          direction: direction,
          duration: duration)
      }
      
      mBlocks.append(block)
    }
  }
  
  //**
  func createGoal(with size: CGSize) {
    let w = (size.width + size.height) * 0.01
    mGoal = SKShapeNode.init(circleOfRadius: CGFloat(w/2))
    mGoal.name = "goal"
    mGoal.strokeColor = .red
    mGoal.lineWidth = 2.5
    mGoal.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(w/2))
    mGoal.physicsBody?.restitution = 0.75
    mGoal.physicsBody?.isDynamic = false
    mGoal.physicsBody?.contactTestBitMask = 0b0001
    
    mGoal.position = mGoalOptions.mStartPosition
  }
  
  //**
  func createPath(atPoint pos: CGPoint) {
    mPathPoints.append(pos)
    mPath = SKShapeNode.init(
      splinePoints: &mPathPoints,
      count: mPathPoints.count)
    mPath.name = "path"
    mPath.lineWidth = 2.5
    mPath.physicsBody = SKPhysicsBody(edgeChainFrom: mPath.path!)
    mPath.physicsBody?.isDynamic = false
    mPath.physicsBody?.contactTestBitMask = 0b0001
  }
}

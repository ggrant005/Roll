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
}

//
//  Level3.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

class Level3 : Level {
  override init() {
    super.init()
    mLevelOptions.mBallOptions = BallOptions()
    mLevelOptions.mBallOptions.mIsDynamic = false
    mLevelOptions.mBallOptions.mStartPosition = CGPoint(x: 25, y: -100)
    
    mLevelOptions.mBlockOptions = BlockOptions()
    mLevelOptions.mBlockOptions.mStartPosition = CGPoint(x: 50, y: -300)
    mLevelOptions.mBlockOptions.mMovementDuration = TimeInterval(0.2)
    mLevelOptions.mBlockOptions.mMovementType = MovementType.mRotate
    mLevelOptions.mBlockOptions.mXTrans = CGFloat(0)
    mLevelOptions.mBlockOptions.mYTrans = CGFloat(0)
    mLevelOptions.mBlockOptions.mRotationAngle = .pi / 2
    
    mLevelOptions.mGoalOptions = GoalOptions()
    mLevelOptions.mGoalOptions.mStartPosition = CGPoint(x: 100, y: -350)
  }
}

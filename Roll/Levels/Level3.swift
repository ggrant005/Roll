//
//  Level3.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
class Level3 : Level {
  override init() {
    super.init()
    mLevelOptions.mBallOptions = BallOptions()
    mLevelOptions.mBallOptions.mIsDynamic = false
    mLevelOptions.mBallOptions.mStartPosition = CGPoint(x: 50, y: -400)
    
    mLevelOptions.mBlockOptions = BlockOptions()
    mLevelOptions.mBlockOptions.mStartPosition = CGPoint(x: 50, y: -300)
    mLevelOptions.mBlockOptions.mXTrans = CGFloat(0)
    mLevelOptions.mBlockOptions.mYTrans = CGFloat(100)
    mLevelOptions.mBlockOptions.mMovementDuration = TimeInterval(0.1)
    
    mLevelOptions.mGoalOptions = GoalOptions()
    mLevelOptions.mGoalOptions.mStartPosition = CGPoint(x: 100, y: -350)
  }
}

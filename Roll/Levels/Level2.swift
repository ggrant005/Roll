//
//  Level2.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

class Level2 : Level {
  override init() {
    super.init()
    mLevelOptions.mBallOptions = BallOptions()
    mLevelOptions.mBallOptions.mIsDynamic = true
    mLevelOptions.mBallOptions.mStartPosition = CGPoint(x: 0, y: 50)
    
    mLevelOptions.mBlockOptions = BlockOptions()
    mLevelOptions.mBlockOptions.mStartPosition = CGPoint(x: 0, y: 0)
    mLevelOptions.mBlockOptions.mMovement = .mTranslate(0, 700, 5)
    
    mLevelOptions.mGoalOptions = GoalOptions()
    mLevelOptions.mGoalOptions.mStartPosition = CGPoint(x: 0, y: -350)
  }
}

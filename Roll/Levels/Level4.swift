//
//  Level3.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

class Level4 : Level {
  override init() {
    super.init()
    mBallOptions = BallOptions()
    mBallOptions.mIsDynamic = false
    mBallOptions.mStartPosition = CGPoint(x: -200, y: 300)
    
    mBlockOptions = BlockOptions()
    mBlockOptions.mStartPosition = CGPoint(x: 50, y: -300)
    mBlockOptions.mMovement = .mSpin(0.5)
    
    mGoalOptions = GoalOptions()
    mGoalOptions.mStartPosition = CGPoint(x: 100, y: -350)
  }
}

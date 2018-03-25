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
    mBallOptions = BallOptions()
    mBallOptions.mIsDynamic = true
    mBallOptions.mStartPosition = CGPoint(x: 0, y: 50)
    
    mBlockOptions = BlockOptions()
    mBlockOptions.mStartPosition = CGPoint(x: 0, y: 0)
    mBlockOptions.mMovement = .mTranslate(0, 700, 5)
    
    mGoalOptions = GoalOptions()
    mGoalOptions.mStartPosition = CGPoint(x: 0, y: -350)
  }
}

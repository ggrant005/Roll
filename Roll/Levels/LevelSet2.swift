//
//  LevelSet2.swift
//  Roll
//
//  Created by Greg Grant on 3/25/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import Foundation
import SpriteKit

class LevelSet2 {
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  class Level1: Level {
    override init() {
      super.init()
      mBallOptions = BallOptions()
      mBallOptions.mIsDynamic = false
      mBallOptions.mStartPosition = CGPoint(x: -200, y: 300)
      
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 50, y: -300)
      options.mMovement = .mRotate(.pi, 0.2)
      mBlockOptions.append(options)
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 100, y: -350)
    }
  }
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  class Level2: Level {
    override init() {
      super.init()
      mBallOptions = BallOptions()
      mBallOptions.mIsDynamic = false
      mBallOptions.mStartPosition = CGPoint(x: -200, y: 300)
      
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 50, y: -300)
      options.mMovement = .mSpin(0.5)
      mBlockOptions.append(options)
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 100, y: -350)
    }
  }
}

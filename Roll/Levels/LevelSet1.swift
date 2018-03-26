//
//  LevelSet1.swift
//  Roll
//
//  Created by Greg Grant on 3/25/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import Foundation
import SpriteKit

class LevelSet1 {
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  class Level1: Level {
    override init() {
      super.init()
      mBallOptions = BallOptions()
      mBallOptions.mIsDynamic = false
      mBallOptions.mStartPosition = CGPoint(x: -200, y: 300)
      
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 0, y: 0)
      options.mMovement = .mTranslate(0, 700, 5)
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
      mBallOptions.mIsDynamic = true
      mBallOptions.mStartPosition = CGPoint(x: 0, y: 50)
      
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 0, y: 0)
      options.mMovement = .mTranslate(0, 700, 5)
      mBlockOptions.append(options)
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 0, y: -350)
    }
  }
}

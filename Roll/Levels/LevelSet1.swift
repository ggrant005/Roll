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
  
  //**
  class Level1: Level {
    override init() {
      super.init()
      
      mBallOptions = BallOptions()
      mBallOptions.mIsDynamic = false
      mBallOptions.mStartPosition = CGPoint(x: 50, y: 1000)
      
      let dist = 100
      let movement = Direction.eLeft
      let duration = 1.0
      let angle = π / 2
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 0, y: dist)
      options.mMovement = .eTurn(movement, angle, duration)
      mBlockOptions.append(options)
      options.mStartPosition = CGPoint(x: dist, y: 0)
      options.mMovement = .eTurn(movement, angle, duration)
      mBlockOptions.append(options)
      options.mStartPosition = CGPoint(x: 0, y: -dist)
      options.mMovement = .eTurn(movement, angle, duration)
      mBlockOptions.append(options)
      options.mStartPosition = CGPoint(x: -dist, y: 0)
      options.mMovement = .eTurn(movement, angle, duration)
      mBlockOptions.append(options)
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 0, y: 0)
    }
  }
  
  //**
  class Level2: Level {
    override init() {
      super.init()
      
      mBallOptions = BallOptions()
      mBallOptions.mIsDynamic = false
      mBallOptions.mStartPosition = CGPoint(x: -200, y: 300)
      
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 0, y: 0)
      options.mMovement = .eSlide(.eUp, 700, 5)
      mBlockOptions.append(options)
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 100, y: -350)
    }
  }
  
  //**
  class Level3: Level {
    override init() {
      super.init()
      
      mBallOptions = BallOptions()
      mBallOptions.mIsDynamic = true
      mBallOptions.mStartPosition = CGPoint(x: 0, y: 50)
      
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 0, y: 0)
      options.mMovement = .eSlide(.eUp, 700, 5)
      mBlockOptions.append(options)
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 0, y: -350)
    }
  }
  
  //**
  class Level4: Level {
    override init() {
      super.init()
      
      mBallOptions = BallOptions()
      mBallOptions.mIsDynamic = false
      mBallOptions.mStartPosition = CGPoint(x: -200, y: 300)
      
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 50, y: -300)
      options.mMovement = .eSeesaw(.eLeft, π, 0.2)
      mBlockOptions.append(options)
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 100, y: -350)
    }
  }
  
  //**
  class Level5: Level {
    override init() {
      super.init()
      
      mBallOptions = BallOptions()
      mBallOptions.mIsDynamic = false
      mBallOptions.mStartPosition = CGPoint(x: -200, y: 300)
      
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 50, y: -300)
      options.mMovement = .eSpin(.eRight, 0.5)
      mBlockOptions.append(options)
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 100, y: -350)
    }
  }
}

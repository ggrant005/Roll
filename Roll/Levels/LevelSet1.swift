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
      mBallOptions.mStartPosition = CGPoint(x: -200, y: 375)
      
      for i in -3...3 {
        for j in [-3, -1, 1, 3] {
          var options = BlockOptions()
          options.mStartPosition = CGPoint(x: j * 75, y: i * 150)
          options.mMovement = .eSpin(((i + j) % 2 == 0) ? .eLeft : .eRight, 0.75)
          mBlockOptions.append(options)
        }
      }
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 100, y: -250)
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

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
  
  //**
  class Level1: Level {
    override init() {
      super.init()
      
      mBallOptions = BallOptions()
      mBallOptions.mIsDynamic = false
      mBallOptions.mStartPosition = CGPoint(x: -200, y: 300)
      
      var options = BlockOptions()
      options.mStartPosition = CGPoint(x: 50, y: -200)
      options.mMovement = .eSeesaw(.eLeft, π, 0.3)
      mBlockOptions.append(options)
      options.mStartPosition = CGPoint(x: -50, y: -200)
      options.mMovement = .eSpin(.eRight, 0.25)
      mBlockOptions.append(options)
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 100, y: -350)
    }
  }
  
  //**
  class Level2: Level {
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
  class Level3: Level {
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
}

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
      mBallOptions.mStartPosition = CGPoint(x: -200, y: 300)
      
      for i in 0 ..< 5 {
        for j in 0 ..< 5 {
          var options = BlockOptions()
          options.mStartPosition = CGPoint(x: j * 150 - 250, y: i * 150 - 250)
          options.mMovement = .eSpin((i + j % 2 == 0) ? .eLeft : .eRight, 0.5)
          mBlockOptions.append(options)
        }
      }
      
      mGoalOptions = GoalOptions()
      mGoalOptions.mStartPosition = CGPoint(x: 100, y: -250)
    }
  }
}

//
//  LevelUtils.swift
//  Roll
//
//  Created by Greg Grant on 3/25/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import Foundation

//**
func getLevel(_ num: (Int, Int)) -> Level {
  switch num.0 {
  case 1:
    switch num.1 {
    case 1:
      return LevelSet1.Level1()
    case 2:
      return LevelSet1.Level2()
    case 3:
      return LevelSet1.Level3()
    case 4:
      return LevelSet1.Level4()
    case 5:
      return LevelSet1.Level5()
    default:
      return LevelSet1.Level1()
    }
  case 2:
    switch num.1 {
    default:
      return LevelSet1.Level1()
    }
  default:
    return LevelSet1.Level1()
  }
}

//
//  LevelUtilities.swift
//  Roll
//
//  Created by Greg Grant on 3/25/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import Foundation

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
func getLevel(_ num: (Int, Int)) -> Level {
  switch num.0 {
  case 1:
    switch num.1 {
    case 1:
      return LevelSet1.Level1()
    case 2:
      return LevelSet1.Level2()
    default:
      return LevelSet1.Level1()
    }
  case 2:
    switch num.1 {
    case 1:
      return LevelSet2.Level1()
    case 2:
      return LevelSet2.Level2()
    default:
      return LevelSet2.Level1()
    }
  default:
    return LevelSet1.Level1()
  }
}

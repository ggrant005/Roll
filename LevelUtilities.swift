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
func getLevel(_ num: Int) -> Level {
  switch num {
  case 1:
    return Level1()
  case 2:
    return Level2()
  case 3:
    return Level3()
  case 4:
    return Level4()
  default:
    return Level1()
  }
}

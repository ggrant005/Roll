//
//  Movement.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

let π = CGFloat.pi

enum Direction {
  case eUp
  case eDown
  case eLeft
  case eRight
}

enum Movement {
  case eSeesaw(Direction, CGFloat, TimeInterval)
  case eSlide(Direction, CGFloat, TimeInterval)
  case eSpin(Direction, TimeInterval)
}

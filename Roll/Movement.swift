//
//  MovementType.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

enum Movement {
  case mTranslate(CGFloat, CGFloat, TimeInterval)
  case mRotate(CGFloat, TimeInterval)
  case mSpin(TimeInterval)
}

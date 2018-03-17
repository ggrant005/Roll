//
//  BlockMovement.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

class BlockMovement {
  
  static func loop(
    shapeNode: SKShapeNode,
    xTranslation: CGFloat,
    yTranslation: CGFloat,
    duration: TimeInterval) {
    
    let firstMove = SKAction.moveBy(
      x: -xTranslation / 2,
      y: -yTranslation / 2,
      duration: duration / 2)
    
    let secondMove = SKAction.moveBy(
      x: xTranslation,
      y: yTranslation,
      duration: duration)
    
    let moveLoop = SKAction.sequence([firstMove, secondMove, firstMove])
    let moveForever = SKAction.repeatForever(moveLoop)
    
    shapeNode.run(moveForever)
  }
  
  static func loop(
    shapeNode: SKShapeNode,
    byAngle: CGFloat,
    duration: TimeInterval) {
    
    let firstMove = SKAction.rotate(
      byAngle: -byAngle / 2,
      duration: duration / 2)
    
    let secondMove = SKAction.rotate(
      byAngle: byAngle,
      duration: duration)
    
    let moveLoop = SKAction.sequence([firstMove, secondMove, firstMove])
    let moveForever = SKAction.repeatForever(moveLoop)
    
    shapeNode.run(moveForever)
  }
}

//
//  BlockMovement.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

class BlockMovement {
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  static func loopTranslate(
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
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  static func loopRotate(
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
  
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  static func loopSpin(
    shapeNode: SKShapeNode,
    duration: TimeInterval) {
    
    let spin = SKAction.rotate(
      byAngle: 2 * .pi,
      duration: duration)
    
    let spinForever = SKAction.repeatForever(spin)
    
    shapeNode.run(spinForever)
  }
}

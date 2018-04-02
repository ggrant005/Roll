//
//  BlockMovement.swift
//  Roll
//
//  Created by Greg Grant on 3/11/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit

class BlockMovement {
  
  //**
  static func seesaw(
    shapeNode: SKShapeNode,
    direction: Direction,
    byAngle: CGFloat,
    duration: TimeInterval) {
    
    let angle = (direction == .eRight) ? -byAngle : byAngle
    
    let firstMove = SKAction.rotate(
      byAngle: angle / 2,
      duration: duration / 2)
    
    let secondMove = SKAction.rotate(
      byAngle: -angle,
      duration: duration)
    
    let moveLoop = SKAction.sequence([firstMove, secondMove, firstMove])
    let moveForever = SKAction.repeatForever(moveLoop)
    
    shapeNode.run(moveForever)
  }
  
  //**
  static func slide(
    shapeNode: SKShapeNode,
    direction: Direction,
    distance: CGFloat,
    duration: TimeInterval) {
    
    var xTrans, yTrans : CGFloat
    switch direction {
    case .eUp:
      xTrans = 0
      yTrans = distance
    case .eDown:
      xTrans = 0
      yTrans = -distance
    case .eLeft:
      xTrans = -distance
      yTrans = 0
    case .eRight:
      xTrans = distance
      yTrans = 0
    }
    
    let firstMove = SKAction.moveBy(
      x: xTrans / 2,
      y: yTrans / 2,
      duration: duration / 2)
    
    let secondMove = SKAction.moveBy(
      x: -xTrans,
      y: -yTrans,
      duration: duration)
    
    let moveLoop = SKAction.sequence([firstMove, secondMove, firstMove])
    let moveForever = SKAction.repeatForever(moveLoop)
    
    shapeNode.run(moveForever)
  }
  
  //**
  static func spin(
    shapeNode: SKShapeNode,
    direction: Direction,
    duration: TimeInterval) {
    
    let angle = (direction == .eRight) ? (-2.0 * π) : (2.0 * π)
    
    let spin = SKAction.rotate(
      byAngle: angle,
      duration: duration)
    
    let spinForever = SKAction.repeatForever(spin)
    
    shapeNode.run(spinForever)
  }
}

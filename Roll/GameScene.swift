//
//  GameScene.swift
//  Roll
//
//  Created by Greg Grant on 1/7/18.
//  Copyright © 2018 Greg Grant. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  
  var entities = [GKEntity]()
  var graphs = [String : GKGraph]()

  private var lastUpdateTime : TimeInterval = 0
  private var circleNode : SKShapeNode?
  
  override func sceneDidLoad() {

  self.lastUpdateTime = 0
      
  // Create shape node
  let w = (self.size.width + self.size.height) * 0.03
  self.circleNode = SKShapeNode.init(circleOfRadius: CGFloat(w))
      
    if let circleNode = self.circleNode {
      circleNode.lineWidth = 2.5
          
      //  .run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
      //circleNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
      //                                  SKAction.fadeOut(withDuration: 0.5),
      //                                  SKAction.removeFromParent()]))
      }
  }
  
  
  func touchDown(atPoint pos : CGPoint) {
    if let n = self.circleNode?.copy() as! SKShapeNode? {
      n.position = pos
//      n.strokeColor = SKColor.green
      self.addChild(n)
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    self.removeAllChildren()
    if let n = self.circleNode?.copy() as! SKShapeNode? {
      n.position = pos
      self.addChild(n)
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    self.removeAllChildren()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
      
    // Initialize _lastUpdateTime if it has not already been
    if (self.lastUpdateTime == 0) {
      self.lastUpdateTime = currentTime
    }
      
    // Calculate time since last update
    let dt = currentTime - self.lastUpdateTime
      
    // Update entities
    for entity in self.entities {
      entity.update(deltaTime: dt)
    }
      
    self.lastUpdateTime = currentTime
  }
}

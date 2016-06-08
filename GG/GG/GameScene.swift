//
//  GameScene.swift
//  GG
//
//  Created by Kyle Davidson on 14/05/2016.
//  Copyright (c) 2016 Kyle Davidson. All rights reserved.
//

import SpriteKit

private struct Constants {
    static let noOfPedals = 6
    static let noOfRows = 3
}

class GameScene: SKScene {
    
    var pedals: [Pedal] = []
    var rows: [Row] = []
    var living: [DynamicSprite] = []
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        self.generateWorld()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func generateWorld() {
        /// Generate Pedals
        guard let pedals = Pedal.generate(self, sequence: 1...Constants.noOfPedals),
            rows = Row.generate(self, sequence: 1...Constants.noOfRows) else {
            assertionFailure("Something's wrong with the world")
            return
        }
        
        self.pedals = pedals
        self.rows = rows
        
        /// Add Sprites to Living Array
        self.living.appendContentsOf(pedals.flatMap { $0 as DynamicSprite })
        
        let wait = SKAction.waitForDuration(3, withRange: 2)
        let spawn = SKAction.runBlock {
            let row = Int(arc4random_uniform(3))
            guard row < self.rows.count else {
                assertionFailure("Row out of bounds")
                return
            }
            
            Coin.spawnAtNode(self.rows[row])
        }
        
        let sequence = SKAction.sequence([wait, spawn])
        self.runAction(SKAction.repeatActionForever(sequence))
    }
}

// MARK: Touches

extension GameScene {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            notifiyWorld(location, touchType: .Began)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            notifiyWorld(location, touchType: .Moved)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            notifiyWorld(location, touchType: .Ended)
        }
    }
    
    private func notifiyWorld(location: CGPoint, touchType: TouchType) {
        for pedal in pedals {
            pedal.notifyTouch(touchType, scene: self, location: location)
        }
    }
}

// MARK: Physics

extension GameScene: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
    }
}

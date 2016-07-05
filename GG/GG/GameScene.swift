//
//  GameScene.swift
//  GG
//
//  Created by Kyle Davidson on 14/05/2016.
//  Copyright (c) 2016 Kyle Davidson. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene {
    var pedals: [Pedal] = []
    var rows: [Row] = []
    var living: [DynamicSprite] = []
    var score: Int = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        self.generateWorld()
    }
   
    override func update(currentTime: CFTimeInterval) {
        for pedal in pedals {
            pedal.update(currentTime)
        }
    }
    
    func generateWorld() {
        /// Generate Pedals
        guard let pedals = Pedal.generate(self, sequence: 1...Constants.PedalAmount),
            rows = Row.generate(self, sequence: 1...Constants.RowAmount) else {
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
            
            let diceRoll = Int(arc4random_uniform(2))
            if diceRoll == 1 {
                let bomb = Bomb.spawnAtNode(self.rows[row])
                bomb?.delegate = self
            } else {
                let bb = BasketBall.spawnAtNode(self.rows[row])
                bb?.delegate = self
            }
        }
        
        let sequence = SKAction.sequence([wait, spawn])
        self.runAction(SKAction.repeatActionForever(sequence))
    }
    
    func updateScore() {
        score = score + 1
        let scoreText = String(format: "%03d", score)
        for var i = 0; i < rows.count; i += 1 {
            rows[i].scoreDigit.text = "\(scoreText[i])"
        }
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

// MARK: Conveyer Delegate
extension GameScene: ConveyerItemDelegate {
    func conveyerItemDidTrigger(item: Coin) {
        switch item.type {
        case .BasketBall:
            print("bb")
        case .Bomb:
            print("boom")
        }
        
        updateScore()
    }
    
    func conveyerItemDidMiss(item: Coin) {
        //no-op-yet
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
        
        if (firstBody.categoryBitMask == Constants.PedalCategory) {
            let pedal = firstBody.node as? Pedal
            pedal?.contactBeganWith(secondBody.node)
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if (firstBody.categoryBitMask == Constants.PedalCategory) {
            let pedal = firstBody.node as? Pedal
            pedal?.contactEndedWith(secondBody.node)
        }
    }
}

// Mark: String Utility 
extension String {
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}


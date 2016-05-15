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
}

class GameScene: SKScene {
    
    var pedals: [Pedal] = []
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self
        self.setupPedals()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func setupPedals() {
        for i in 1...Constants.noOfPedals {
            if let pedalRef = self.childNodeWithName("pedal_\(i)") as? SKReferenceNode,
                pedal = pedalRef.childNodeWithName("pedal") as? Pedal {
                pedals.append(pedal)
                assert(pedals.count == Constants.noOfPedals)
            }
        }
    }
}

// MARK: Touches

extension GameScene {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            
            if let pedal = touchedNode as? Pedal {
                pedal.pushDown()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            
            if let pedal = touchedNode as? Pedal {
                pedal.pullUp()
            }
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

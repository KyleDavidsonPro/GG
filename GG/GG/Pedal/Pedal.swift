//
//  Pedal.swift
//  GG
//
//  Created by Kyle Davidson on 15/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import SpriteKit

class Pedal: SKSpriteNode {
    
    private var originalColor: UIColor!
    private var pressed = false
    weak private var intersecting: SKNode?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.originalColor = self.color
    }
    
    func pushDown() {
        self.color = UIColor.clearColor()
        self.pressed = true
    }
    
    func pullUp() {
        self.color = originalColor
        self.pressed = false
    }
    
}

// Mark: Dynamic Sprite

extension Pedal: DynamicSprite {
    
    func update(currentTime: CFTimeInterval) {
        if let node = self.intersecting as? ConveyerItem where self.pressed {
            node.trigger()
        }
    }
    
    func notifyTouch(touchType: TouchType, scene: SKScene, location: CGPoint) {
        if self == scene.nodeAtPoint(location) {
            switch touchType {
            case .Began:
                touchBegan()
            case.Ended:
                touchEnded()
            default:
                touchEnded()
            }
        } else {
            pullUp()
        }
    }
    
    func touchBegan() {
        pushDown()
    }
    
    func touchEnded() {
        pullUp()
    }
    
    func contactBeganWith(node: SKNode?) {
        guard let node = node where node.physicsBody?.categoryBitMask == Constants.CoinCategory else {
            assertionFailure("Wrong contact")
            return
        }
        
        self.intersecting = node
    }
    
    func contactEndedWith(node: SKNode?) {
        guard let node = node where node.physicsBody?.categoryBitMask == Constants.CoinCategory else {
            assertionFailure("Wrong contact")
            return
        }
        
        if let conveyerNode = node as? ConveyerItem {
            conveyerNode.miss()
        }
        
        self.intersecting = nil
    }
}

// Mark: Generator Sprite
extension Pedal: GeneratorSprite {
    static func generate(scene: SKScene, sequence: Range<Int>?) -> [Pedal]? {
        var copies: [Pedal] = []
        
        if let sequence = sequence {
            for i in sequence {
                if let pedalRef = scene.childNodeWithName("pedal_\(i)") as? SKReferenceNode,
                    pedal = pedalRef.childNodeWithName(".//pedal") as? Pedal {
                    copies.append(pedal)
                }
            }
        } else {
            if let pedalRef = scene.childNodeWithName("pedal") as? SKReferenceNode,
                pedal = pedalRef.childNodeWithName(".//pedal") as? Pedal {
                copies.append(pedal)
            }
        }
        
        //fallback if sequence wasn't expected
        guard sequence?.count == copies.count && copies.count > 0 else {
            return nil
        }
        
        return copies
    }
}
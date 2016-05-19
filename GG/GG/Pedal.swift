//
//  Pedal.swift
//  GG
//
//  Created by Kyle Davidson on 15/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import SpriteKit

class Pedal: SKSpriteNode {
    
    var originalColor: UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.originalColor = self.color
    }
    
    func pushDown() {
        self.color = UIColor.clearColor()
    }
    
    func pullUp() {
        self.color = originalColor
    }
    
}

// Mark: Dynamic Sprite

extension Pedal: DynamicSprite {
    
    func update(currentTime: CFTimeInterval) {
        //no-op
    }
    
    func notifyTouch(touchType: TouchType, scene: SKScene, location: CGPoint) {
        if self == scene.nodeAtPoint(location) {
            switch touchType {
            case .Began:
                touchBegan()
            case .Moved:
                touchMoved()
            case.Ended:
                touchEnded()
            }
        } else {
            pullUp()
        }
    }
    
    func touchBegan() {
        pushDown()
    }
    
    func touchMoved() {
        pushDown()
    }
    
    func touchEnded() {
        pullUp()
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
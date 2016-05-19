//
//  Coin.swift
//  GG
//
//  Created by Kyle Davidson on 18/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        let texture = SKTexture(imageNamed: "Spaceship")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.size = CGSize(width: 25, height: 25)
    }
    
    func configureWithNode(node: SKNode) {
        let actionMove: SKAction
        let actionMoveDone: SKAction
        
        // Determine speed of the coin
        let minDuration: UInt32 = 2
        let maxDuration: UInt32 = 4
        let rangeDuration: UInt32 = maxDuration - minDuration
        let actualDuration = (arc4random() % rangeDuration) + minDuration
        
        // Left or right
        let diceRoll = Int(arc4random_uniform(2))
        
        if diceRoll == 0 {
            actionMove = SKAction.moveToX(-self.size.width/2, duration: Double(actualDuration))
            actionMoveDone = SKAction.removeFromParent()
        } else {
            actionMove = SKAction.moveToX(node.frame.size.width + (self.size.width / 2), duration: Double(actualDuration))
            actionMoveDone = SKAction.removeFromParent()
        }
        
        self.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
}

extension Coin: Spawnable {
    static func spawnAtNode(node: SKNode) -> Coin? {
        let coin = Coin()
        coin.configureWithNode(node)
        node.addChild(coin)
        
        return coin
    }
}
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
        self.size = CGSize(width: 100, height: 100)
        self.physicsBody = nil
        self.position = CGPointZero
        self.zPosition = 2
    }
    
    func configureWithNode(node: SKNode) {
        let actionMove: SKAction
        let actionMoveDone: SKAction
        
        // Left or right
        let diceRoll = Int(arc4random_uniform(2))
        var x: CGFloat
        if diceRoll == 0 {
            x = -node.frame.width/2 + -self.size.width/2
        } else {
            x = self.size.width/2 + node.frame.width/2
        }
        
        actionMove = SKAction.moveToX(x, duration: 4.0)
        actionMoveDone = SKAction.removeFromParent()
        
        self.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
}

extension Coin: Spawnable {
    static func spawnAtNode(node: SKNode) -> Coin? {
        let coin = Coin()
        node.addChild(coin)
        coin.configureWithNode(node)
        
        return coin
    }
}
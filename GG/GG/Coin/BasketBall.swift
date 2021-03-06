//
//  Coin.swift
//  GG
//
//  Created by Kyle Davidson on 18/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import Foundation
import SpriteKit

class BasketBall: SKSpriteNode, Coin {
    let type: CoinType = .BasketBall
    var delegate: ConveyerItemDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        let texture = SKTexture(imageNamed: "basketball")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.zPosition = 2
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.categoryBitMask = Constants.CoinCategory
        self.physicsBody?.contactTestBitMask = Constants.PedalCategory
        self.physicsBody?.dynamic = false
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
        
        actionMove = SKAction.moveToX(x, duration: 1)
        actionMoveDone = SKAction.removeFromParent()
        
        self.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
}

extension BasketBall: ConveyerItem {
    func trigger() {
        delegate.conveyerItemDidTrigger(self)
        self.removeFromParent()
    }
    
    func miss() {
        delegate.conveyerItemDidMiss(self)
        self.removeFromParent()
    }
}

extension BasketBall: Spawnable {
    static func spawnAtNode(node: SKNode) -> BasketBall? {
        let basketball = BasketBall()
        node.addChild(basketball)
        basketball.configureWithNode(node)
        
        return basketball
    }
}
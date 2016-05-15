//
//  Pedal.swift
//  GG
//
//  Created by Kyle Davidson on 15/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import SpriteKit

class Pedal: SKSpriteNode {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pushDown() {
        print("hello")
    }
    
    func pullUp() {
        print("goodbye")
    }
}

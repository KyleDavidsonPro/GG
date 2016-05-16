//
//  DynamicType.swift
//  GG
//
//  Created by Kyle Davidson on 16/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import Foundation
import SpriteKit

protocol DynamicSprite: class {
    func update(currentTime: CFTimeInterval) -> Void
    func touchBegan(scene: SKScene, location: CGPoint) -> Void
    func touchMoved(scene: SKScene, location: CGPoint) -> Void
    func touchEnded(scene: SKScene, location: CGPoint) -> Void
}

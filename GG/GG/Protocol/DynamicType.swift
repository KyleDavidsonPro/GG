//
//  DynamicType.swift
//  GG
//
//  Created by Kyle Davidson on 16/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import Foundation
import SpriteKit

enum TouchType {
    case Began
    case Moved
    case Ended
}

protocol DynamicSprite: class {
    func update(currentTime: CFTimeInterval) -> Void
    func notifyTouch(touchType: TouchType, scene: SKScene, location: CGPoint) -> Void
    func touchBegan() -> Void
    func touchEnded() -> Void
    func contactBeganWith(node: SKNode?) -> Void
    func contactEndedWith(node: SKNode?) -> Void
}

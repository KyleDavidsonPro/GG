//
//  GeneratorType.swift
//  GG
//
//  Created by Kyle Davidson on 16/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import Foundation
import SpriteKit

protocol GeneratorSprite: class {
    associatedtype Object
    static func generate(scene: SKScene, sequence: Range<Int>?) -> [Object]?
}
//
//  SpawnableType.swift
//  GG
//
//  Created by Kyle Davidson on 19/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import Foundation
import SpriteKit

enum CoinType {
    case BasketBall
    case Bomb
}

protocol Coin: class {
    var type: CoinType { get }
}

/// Used to spawn sprites managed in their own sks files
protocol Spawnable: class {
    associatedtype Object
    static func spawnAtNode(node: SKNode) -> Object?
}

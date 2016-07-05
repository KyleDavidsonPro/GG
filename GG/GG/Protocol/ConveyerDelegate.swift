//
//  FinishDelegate.swift
//  GG
//
//  Created by Kyle Davidson on 27/06/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import Foundation
import SpriteKit

/// Used to notify delegate of crossing the finish line or hit by pedal
protocol ConveyerItem: class {
    func trigger() -> Void
    func miss() -> Void
}

protocol ConveyerItemDelegate: class {
    func conveyerItemDidTrigger(item: Coin) -> Void
    func conveyerItemDidMiss(item: Coin) -> Void
}
//
//  Row.swift
//  GG
//
//  Created by Kyle Davidson on 18/05/2016.
//  Copyright © 2016 Kyle Davidson. All rights reserved.
//

import Foundation
import SpriteKit

class Row: SKSpriteNode {
    var scoreDigit: SKLabelNode = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scoreDigit.fontSize = 40
        scoreDigit.fontColor = SKColor.whiteColor()
        print(scoreDigit.position)
        scoreDigit.text = "0"
        self.addChild(scoreDigit)
    }
}

extension Row: GeneratorSprite {
    static func generate(scene: SKScene, sequence: Range<Int>?) -> [Row]? {
        var copies: [Row] = []
        
        if let sequence = sequence {
            for i in sequence {
                if let rowRef = scene.childNodeWithName("row_\(i)") as? SKReferenceNode,
                    row = rowRef.childNodeWithName(".//row") as? Row {
                    copies.append(row)
                }
            }
        } else {
            if let rowRef = scene.childNodeWithName("row") as? SKReferenceNode,
                row = rowRef.childNodeWithName(".//row") as? Row {
                copies.append(row)
            }
        }
        
        //fallback if sequence wasn't expected
        guard sequence?.count == copies.count && copies.count > 0 else {
            return nil
        }
        
        return copies
    }
}
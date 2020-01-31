//
//  GameLog.swift
//  Chess
//
//  Created by Tim Colla on 30/01/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import Foundation

struct GameLog {
    var moves = [Move]()

    mutating func add(_ move: Move) {
        moves.append(move)
    }

    func toAN() {
        for (i, move) in moves.enumerated() {
            if (i+1)%2 == 1 {
                print(ceil(Double(i+1)/2.0))
            }
            print(move.piece.algebraicNotation+""+Square(withIndex: move.from).toAN()+""+Square(withIndex: move.to).toAN())
        }
    }
}

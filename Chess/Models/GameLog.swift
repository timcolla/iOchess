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

    /// Convert GameLog to Algebraic Notation
    func toAN() {
        for (i, move) in moves.enumerated() {
            let fromSquare = Square(withIndex: move.from)

            if (i+1)%2 == 1 {
                print(ceil(Double(i+1)/2.0))
            }
            var stringMove = ""
            stringMove += move.piece.algebraicNotation

            if move.piece is Pawn, move.capture {
                stringMove += fromSquare.file
            }

            if move.ambiguousFile {
                stringMove += fromSquare.file
            }
            if move.ambiguousRank {
                stringMove += fromSquare.rank
            }
            if move.capture {
                stringMove += "x"
            }
            stringMove += Square(withIndex: move.to).toAN()

            print(stringMove)
        }
    }
}

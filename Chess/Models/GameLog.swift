//
//  GameLog.swift
//  Chess
//
//  Created by Tim Colla on 30/01/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import Foundation

/** Keeps track of all moves that have been played.
 Able to convert the log into Algebraic Notations
 */
struct GameLog {
    var moves = [Move]()

    mutating func add(_ move: Move) {
        moves.append(move)
    }

    /// Convert GameLog to Algebraic Notation
    func toAN() {
        for (i, move) in moves.enumerated() {
            var stringMove = ""
            if let castle = move.castle {
                stringMove += "\(castle)"
            } else {
                let fromSquare = Square(withIndex: move.from)

                // The move number. One move is after both white and black have moved.
                if (i+1)%2 == 1 {
                    print(ceil(Double(i+1)/2.0))
                }
                stringMove += move.piece.algebraicNotation

                // If a pawn captures we need to show from what file it captured
                if move.piece is Pawn, move.capture {
                    stringMove += fromSquare.file
                }

                // If two or more pieces on the same rank could have moved here, show from what file it came
                if move.ambiguousFile {
                    stringMove += fromSquare.file
                }
                // If two or more pieces on the same file could have moved here, show from what rank it came
                if move.ambiguousRank {
                    stringMove += fromSquare.rank
                }
                // Show if a move was a capture of another piece
                if move.capture {
                    stringMove += "x"
                }
                // Show the square a piece moved to
                stringMove += Square(withIndex: move.to).toAN()

                if move.checkMate {
                    stringMove += "#"
                } else if move.check {
                    stringMove += "+"
                }
            }

            print(stringMove)
        }
    }
}

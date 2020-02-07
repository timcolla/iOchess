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
    func toAN() -> [(Int, String, String)] {
        var anMoves = [(Int, String, String)]()
        for (i, move) in moves.enumerated() {
            var stringMove = ""
            var moveNumber: Int?

            // The move number. One move is after both white and black have moved.
            if (i+1)%2 == 1 {
                moveNumber = Int(ceil(Double(i+1)/2.0))
                //                    print(moveNumber)
            }
            if let castle = move.castle {
                stringMove += "\(castle)"
            } else {
                let fromSquare = Square(withIndex: move.from)

                stringMove += move.piece.algebraicNotation

                // If a pawn captures we need to show from what file it captured
                if move.piece is Pawn, move.capture {
                    stringMove += fromSquare.file
                }
                // If two or more pieces on the same rank could have moved here, show from what file it came
                else if move.ambiguousFile {
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

            if let moveNumber = moveNumber {
                anMoves.append((moveNumber, stringMove, ""))
            } else if var lastMove = anMoves.last {
                lastMove.2 = stringMove
                anMoves[anMoves.count-1] = lastMove
            }
//            print(stringMove)
        }
        return anMoves
    }
}

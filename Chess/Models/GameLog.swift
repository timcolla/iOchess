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

    func exportMoves(_ completion: (URL) -> Void) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        if let moveData = try? jsonEncoder.encode(moves) {

            if let documentsDir = try? FileManager.default.url(for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
                create: false) {

                let file = documentsDir.appendingPathComponent("Chess_log.json")
                FileManager.default.createFile(atPath: file.path, contents: moveData, attributes: nil)

                completion(file)
            }
        }
    }

    mutating func promoted(to piece: Piece, check: Bool = false, checkMate: Bool = false) {
        if var lastMove = moves.last {
            lastMove.promotedTo = piece
            lastMove.check = check
            lastMove.checkMate = checkMate

            moves[moves.count - 1] = lastMove
        }
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

                if let promotedTo = move.promotedTo {
                    stringMove += "=\(promotedTo.algebraicNotation)"
                }

                if move.checkMate {
                    stringMove += "#"
                } else if move.check {
                    stringMove += "+"
                } else if move.draw {
                    stringMove += "½"
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

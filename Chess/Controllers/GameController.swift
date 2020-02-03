//
//  GameController.swift
//  Chess
//
//  Created by Tim Colla on 01/03/2019.
//  Copyright © 2019 Marino Software. All rights reserved.
//

import Foundation

class GameController {
    var board: [Piece?]
    var selectedSquare: Int?
    var gameLog = GameLog()

    init() {
        var movedPawnBlack = Pawn(colour: .black)
        movedPawnBlack.firstMove = false
        var movedPawnWhite = Pawn(colour: .white)
        movedPawnWhite.firstMove = false
        board = [Rook(colour: .black), Knight(colour: .black), Bishop(colour: .black), Queen(colour: .black), King(colour: .black), Bishop(colour: .black), Knight(colour: .black), Rook(colour: .black),
                 Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black),
                 nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil,
                 Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white),
                 Rook(colour: .white), Knight(colour: .white), Bishop(colour: .white), Queen(colour: .white), King(colour: .white), Bishop(colour: .white), Knight(colour: .white), Rook(colour: .white)]
    }

    @discardableResult
    func selectSquare(index: Int) -> Bool {
        guard index > 0, index < board.count else {
            return false
        }

        if let selectedSquare = selectedSquare {
            if let selectedPiece = board[index], let potentialPiece = board[selectedSquare],
            selectedPiece.colour == potentialPiece.colour {
                self.selectedSquare = index
                return true
            } else {
                let possibleSquares = self.possibleSquares(for: selectedSquare)

                // move piece
                if possibleSquares.contains(index) {
                    movePiece(from: selectedSquare, to: index)
                }

                self.selectedSquare = nil
            }
        } else {
            if board[index] != nil {
                selectedSquare = index
                return true
            }
        }
        return false
    }

    func possibleSquares(for index: Int, forCastlingRights: Bool = false) -> [Int] {
        guard let piece = board[index] else {
            return [Int]()
        }

        var possibleSquares = [Int]()
        if let piece = piece as? Pawn {
            for relativeMove in piece.takes {
                let possibleSquare = relativeMove + index
                if possibleSquare >= 0, possibleSquare < board.count, let possiblePiece = board[possibleSquare], possiblePiece.colour != piece.colour {
                    possibleSquares.append(possibleSquare)
                }
            }
        }
        for relativeMove in piece.relativeMoves {
            for i in 1...piece.range {
                if index % 8 == 0 && (relativeMove == 7 || relativeMove == -9 || relativeMove == -1) {
                    break
                }
                if index % 8 == 7 && (relativeMove == -7 || relativeMove == 9 || relativeMove == 1) {
                    break
                }
                if index / 8 == 0 && (relativeMove == -7 || relativeMove == -9 || relativeMove == -8) {
                    break
                }
                if index / 8 == 7 && (relativeMove == 7 || relativeMove == 9 || relativeMove == 8) {
                    break
                }
                let possibleSquare = relativeMove * i + index
                let piecePosition = Square(withIndex: index)
                let possiblePosition = Square(withIndex: possibleSquare)
                if let piece = piece as? Knight, piece.validPossibleSquare(possiblePosition, position: piecePosition) {
                    if let possiblePiece = board[possibleSquare], possiblePiece.colour == piece.colour {
                        break
                    }
                    possibleSquares.append(possibleSquare)
                    if board[possibleSquare] != nil {
                        break
                    }
                } else if let piece = piece as? King, (relativeMove == -2 || relativeMove == 2), !forCastlingRights {
                    if piece.firstMove {
                        let oponentColour: Colour = piece.colour == .white ? .black : .white
                        if relativeMove == 2 {
                            if let rook = board[possibleSquare+1] as? Rook, rook.firstMove,
                                board[possibleSquare-1] == nil,
                                board[possibleSquare] == nil {
                                var possible = true
                                for (oponentIndex, possibleOponentPiece) in board.enumerated() {
                                    if let oponentPiece = possibleOponentPiece,
                                        oponentPiece.colour == oponentColour {
                                        let oponentPossibleSquares = self.possibleSquares(for: oponentIndex)
                                        if oponentPossibleSquares.contains(possibleSquare) ||
                                            oponentPossibleSquares.contains(possibleSquare-1) {
                                            possible = false
                                            break
                                        }
                                    }
                                }
                                if possible {
                                    possibleSquares.append(possibleSquare)
                                }
                            }
                        } else {
                            if let rook = board[possibleSquare-2] as? Rook, rook.firstMove,
                                board[possibleSquare-1] == nil,
                                board[possibleSquare] == nil,
                                board[possibleSquare+1] == nil {
                                    var possible = true
                                    for (oponentIndex, possibleOponentPiece) in board.enumerated() {
                                        if let oponentPiece = possibleOponentPiece,
                                            oponentPiece.colour == oponentColour {
                                            let oponentPossibleSquares = self.possibleSquares(for: oponentIndex, forCastlingRights: true)
                                            if oponentPossibleSquares.contains(possibleSquare) ||
                                                oponentPossibleSquares.contains(possibleSquare+1) {
                                                possible = false
                                                break
                                            }
                                        }
                                    }
                                    if possible {
                                        possibleSquares.append(possibleSquare)
                                    }
                            }
                        }
                    }
                } else if possibleSquare >= 0 && possibleSquare < board.count && !(piece is Knight) {
                    if let possiblePiece = board[possibleSquare], possiblePiece.colour == piece.colour || piece is Pawn {
                        break
                    }
                    possibleSquares.append(possibleSquare)
                    if board[possibleSquare] != nil {
                        break
                    }
                }

                if possibleSquare % 8 == 0 && (relativeMove == 7 || relativeMove == -9 || relativeMove == -1) {
                    break
                }
                if possibleSquare % 8 == 7 && (relativeMove == -7 || relativeMove == 9 || relativeMove == 1) {
                    break
                }
                if possibleSquare / 8 == 0 && (relativeMove == 7 || relativeMove == -9 || relativeMove == -8) {
                    break
                }
                if possibleSquare / 8 == 7 && (relativeMove == -7 || relativeMove == 9 || relativeMove == 8) {
                    break
                }
            }
        }
        return possibleSquares
    }

    func movePiece(from: Int, to: Int) {
        guard from > 0,
            to > 0,
            from < board.count,
            to < board.count,
            let piece = board[from] else {
            return
        }

        // Check if move could be ambiguous
        let (ambiguousFile, ambiguousRank) = checkForAmbiguity(from: from, to: to)

        let toPiece = board[to]
        board[from] = nil
        if var pawn = piece as? Pawn {
            pawn.firstMove = false
            board[to] = pawn
        } else if var king = piece as? King {
            king.firstMove = false
            board[to] = king
        } else if var rook = piece as? Rook {
            rook.firstMove = false
            board[to] = rook
        } else {
            board[to] = piece
        }

        var move = Move(piece: piece, from: from, to: to, ambiguousFile: ambiguousFile, ambiguousRank: ambiguousRank)

        if toPiece != nil,
            toPiece!.colour != piece.colour {
            move.capture = true
        }
        gameLog.add(move)
    }

    func checkForAmbiguity(from: Int, to: Int) -> (ambiguousFile: Bool, ambiguousRank: Bool) {
        let fromPiece = board[from]!

        var ambiguousFile = false
        var ambiguousRank = false
        for (index, piece) in board.enumerated() {
            if piece != nil,
                type(of: piece!) == type(of: fromPiece),
                piece!.colour == fromPiece.colour {

                if possibleSquares(for: index).contains(to) && index != from {
                    let fromSquare = Square(withIndex: from)
                    let indexSquare = Square(withIndex: index)
                    if fromSquare.rank == indexSquare.rank {
                        ambiguousFile = true
                    } else if fromSquare.file == indexSquare.file {
                        ambiguousRank = true
                    } else {
                        ambiguousFile = true
                    }
                }
            }
        }

        return (ambiguousFile, ambiguousRank)
    }
}

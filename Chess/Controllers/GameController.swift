//
//  GameController.swift
//  Chess
//
//  Created by Tim Colla on 01/03/2019.
//  Copyright © 2019 Marino Software. All rights reserved.
//

import Foundation

/** Keeps track of the whole game

 You only have to use selectSquare(index:) every time a square is selected.
 The GameController will apply all game logic needed.
 */
class GameController {
    var board: [Piece?]
    var selectedSquare: Int?
    var gameLog = GameLog()

    var checkedKing: Int?

    var currentPlayer: Colour = .white

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

    /** What index on the board was selected.

     indeces 0-7 are a8-h8
     indeces 8-15 are a7-h7
     indeces 16-23 are a6-h6
     indeces 24-31 are a5-h5
     indeces 32-39 are a4-h4
     indeces 40-47 are a3-h3
     indeces 48-55 are a2-h2
     indeces 56-63 are a1-h1
     */
    @discardableResult
    func selectSquare(index: Int) -> Bool {
        guard index >= 0, index < board.count else {
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
                    currentPlayer = currentPlayer.toggled()
                }

                self.selectedSquare = nil
            }
        } else {
            if board[index] != nil,
                let possiblePiece = board[index],
                possiblePiece.colour == currentPlayer {
                selectedSquare = index
                return true
            }
        }
        return false
    }

    private func forbiddenKingSquares(for piece: King) -> [Int] {
        let oponentColour: Colour = piece.colour == .white ? .black : .white
        var forbiddenSquares = [Int]()
        for (oponentIndex, possibleOponentPiece) in board.enumerated() {
            if let oponentPiece = possibleOponentPiece,
                oponentPiece.colour == oponentColour {
                forbiddenSquares += self.possibleSquares(for: oponentIndex, preventRecursion: true)
            }
        }
        return forbiddenSquares
    }

    /// Returns array of possible indeces for selected piece to move to
    func possibleSquares(for index: Int, preventRecursion: Bool = false) -> [Int] {
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
                } else if let piece = piece as? King, (relativeMove == -2 || relativeMove == 2), !preventRecursion {
                    if piece.firstMove {
                        let oponentColour: Colour = piece.colour == .white ? .black : .white
                        if relativeMove == 2 {
                            if let rook = board[possibleSquare+1] as? Rook, rook.firstMove,
                                board[possibleSquare-1] == nil,
                                board[possibleSquare] == nil {
                                let forbiddenKingSquares = self.forbiddenKingSquares(for: piece)
                                if !forbiddenKingSquares.contains(possibleSquare) &&
                                    !forbiddenKingSquares.contains(possibleSquare-1) {
                                    possibleSquares.append(possibleSquare)
                                }
                            }
                        } else {
                            if let rook = board[possibleSquare-2] as? Rook, rook.firstMove,
                                board[possibleSquare-1] == nil,
                                board[possibleSquare] == nil,
                                board[possibleSquare+1] == nil {
                                    let forbiddenKingSquares = self.forbiddenKingSquares(for: piece)
                                    if !forbiddenKingSquares.contains(possibleSquare) &&
                                        !forbiddenKingSquares.contains(possibleSquare+1) {
                                        possibleSquares.append(possibleSquare)
                                    }
                            }
                        }
                    }
                } else if possibleSquare >= 0 && possibleSquare < board.count && !(piece is Knight) {
                    if let possiblePiece = board[possibleSquare], possiblePiece.colour == piece.colour || piece is Pawn {
                        break
                    }
                    if !preventRecursion, let piece = piece as? King, forbiddenKingSquares(for: piece).contains(possibleSquare) {
                        continue
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

    /**
     Moves piece

     - Parameters:
        - from: From index
        - to: To index
     */
    private func movePiece(from: Int, to: Int) {
        guard from >= 0,
            to >= 0,
            from < board.count,
            to < board.count,
            let piece = board[from] else {
            return
        }
        var move: Move

        if var king = board[from] as? King, from - to == 2, var rook = board[from-4] as? Rook {
            // Long castle
            king.firstMove = false
            rook.firstMove = false
            move = Move(piece: piece, from: from, to: to, castle: .long)

            board[to] = king
            board[to+1] = rook
            board[from-4] = nil
            board[from] = nil
        } else if var king = board[from] as? King, from - to == -2, var rook = board[from-4] as? Rook {
            // Short castle
            king.firstMove = false
            rook.firstMove = false
            move = Move(piece: piece, from: from, to: to, castle: .short)

            board[to] = king
            board[to-1] = rook
            board[from+3] = nil
            board[from] = nil
        } else {
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

            move = Move(piece: piece, from: from, to: to, ambiguousFile: ambiguousFile, ambiguousRank: ambiguousRank)

            if toPiece != nil,
                toPiece!.colour != piece.colour {
                move.capture = true
            }
        }
        gameLog.add(move)
    }

    /// Check to see if move could be ambiguous
    ///
    /// For example if you have a rook on a4 and on h4 and want to move one of them
    /// to d4 it would be ambiguous which rook you'd want to move there.
    /// - Parameters:
    ///    - from: From index
    ///    - to: To index
    private func checkForAmbiguity(from: Int, to: Int) -> (ambiguousFile: Bool, ambiguousRank: Bool) {
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

    func checkForCheck() -> Bool {
        let allDirections: [Int] = [1,9,8,7,-1,-9,-8,-7]
        for (index, piece) in board.enumerated() {
            if let piece = piece as? King {
                for direction in allDirections {
                    for i in 1...7 {
                        let possibleIndex = direction*i+index
                        if possibleIndex >= 0,
                            possibleIndex < board.count,
                            let possiblePiece = board[possibleIndex],
                            possiblePiece.colour != piece.colour {
                            let possibleSquares = self.possibleSquares(for: possibleIndex, preventRecursion: true)
                            if possibleSquares.contains(index) {
                                checkedKing = index
                                return true
                            }
                        }
                    }
                }
            }
        }
        checkedKing = nil
        return false
    }
}

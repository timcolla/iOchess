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
    var possibleSquaresInCheck = [Int]()

    var enPassantablePawn: Int?
    var promotingPawn: Int?

    var currentPlayer: Colour = .white

    init() {
        board = []

        reset()
    }

    func reset() {
        board = [Rook(colour: .black), Knight(colour: .black), Bishop(colour: .black), Queen(colour: .black), King(colour: .black), Bishop(colour: .black), Knight(colour: .black), Rook(colour: .black),
                Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black),
                nil, nil, nil, nil, nil, nil, nil, nil,
                nil, nil, nil, nil, nil, nil, nil, nil,
                nil, nil, nil, nil, nil, nil, nil, nil,
                nil, nil, nil, nil, nil, nil, nil, nil,
                Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white),
                Rook(colour: .white), Knight(colour: .white), Bishop(colour: .white), Queen(colour: .white), King(colour: .white), Bishop(colour: .white), Knight(colour: .white), Rook(colour: .white)]

        selectedSquare = nil
        gameLog = GameLog()
        checkedKing = nil
        possibleSquaresInCheck = [Int]()
        enPassantablePawn = nil
        currentPlayer = .white
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

        if let checkedKing = checkedKing, index != checkedKing, selectedSquare != checkedKing {
            if selectedSquare == nil {
                guard let selectedPiece = board[index], selectedPiece.colour == currentPlayer else {
                    return false
                }
                let possibleSquares = possibleSquaresInCheck.filter(self.possibleSquares(for: index, board: board).contains)
                if possibleSquares.count > 0 {
                    selectedSquare = index
                    return true
                }
                selectedSquare = nil
                return false
            } else {
                let possibleSquares = possibleSquaresInCheck.filter(self.possibleSquares(for: selectedSquare!, board: board).contains)
                if possibleSquares.contains(index) {
                    currentPlayer = currentPlayer.toggled()
                    movePiece(from: selectedSquare!, to: index)
                    selectedSquare = nil
                    return false
                }

                selectedSquare = nil
                return selectSquare(index: index)
            }
        }

        if let selectedSquare = selectedSquare {
            if let selectedPiece = board[index], let potentialPiece = board[selectedSquare],
            selectedPiece.colour == potentialPiece.colour {
                if possibleSquares(for: index, board: board).count > 0 {
                    self.selectedSquare = index
                    return true
                } else {
                    self.selectedSquare = nil
                    return false
                }
            } else {
                let possibleSquares = self.possibleSquares(for: selectedSquare, board: board)

                // move piece
                if possibleSquares.contains(index) {
                    currentPlayer = currentPlayer.toggled()
                    movePiece(from: selectedSquare, to: index)
                }

                self.selectedSquare = nil
            }
        } else {
            if board[index] != nil,
                let possiblePiece = board[index],
                possiblePiece.colour == currentPlayer {
                if possibleSquares(for: index, board: board).count > 0 {
                    selectedSquare = index
                    return true
                } else {
                    selectedSquare = nil
                    return false
                }
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
                forbiddenSquares += self.possibleSquares(for: oponentIndex, board: board, preventRecursion: true)
            }
        }
        return forbiddenSquares
    }

    /// Returns array of possible indeces for selected piece to move to
    func possibleSquares(for index: Int, board: [Piece?], preventRecursion: Bool = false) -> [Int] {
        guard let piece = board[index] else {
            return [Int]()
        }

        if checkedKing != nil, !preventRecursion, !(piece is King) {
            let possibleSquares = possibleSquaresInCheck.filter(self.possibleSquares(for: index, board: board, preventRecursion: true).contains)
            return possibleSquares
        }

        var possibleSquares = [Int]()
        if let piece = piece as? Pawn {
            for relativeMove in piece.takes {
                let possibleSquare = relativeMove + index
                if possibleSquare >= 0, possibleSquare < board.count, let possiblePiece = board[possibleSquare], possiblePiece.colour != piece.colour,
                    abs(index/8-possibleSquare/8) == 1 {
                    possibleSquares.append(possibleSquare)
                    continue
                }
                if let enPassantablePawn = enPassantablePawn,
                        (enPassantablePawn == possibleSquare + 8 && piece.colour == .white) || (enPassantablePawn == possibleSquare - 8 && piece.colour == .black) {
                    print("Take en passantable pawn")
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

        // Only allow squares that don't put your king in check after the move
        if !preventRecursion {
            var possiblePossibleSquares = [Int]()
            for square in possibleSquares {
                var possibleBoard = board
                possibleBoard[square] = possibleBoard[index]
                possibleBoard[index] = nil

                let checkedKing = checkForCheck(board: possibleBoard).checkedKing

                if checkedKing == nil {
                    possiblePossibleSquares.append(square)
                } else if let checkedKing = checkedKing, let king = possibleBoard[checkedKing], king.colour != currentPlayer {
                    possiblePossibleSquares.append(square)
                }
            }
            possibleSquares = possibleSquares.filter(possiblePossibleSquares.contains)
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
        if !(piece is Pawn) {
            enPassantablePawn = nil
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
        } else if var king = board[from] as? King, from - to == -2, var rook = board[from+3] as? Rook {
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

            var toPiece = board[to]
            board[from] = nil
            if var pawn = piece as? Pawn {
                pawn.firstMove = false
                board[to] = pawn

                if let enPassantablePawn = enPassantablePawn,
                    (to == enPassantablePawn - 8 && piece.colour == .white) || (to == enPassantablePawn + 8 && piece.colour == .black) {
                    toPiece = board[enPassantablePawn]
                    board[enPassantablePawn] = nil
                }

                enPassantablePawn = abs(from-to) == 16 ? to : nil

                if to/8 == 0 || to/8 == 7 {
                    promotingPawn = to
                    NotificationCenter.default.post(name: .onPromotePawn, object: Promotion(index: to, colour: pawn.colour))
                }
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

            let (checkedKing, possibleSquaresInCheck) = checkForCheck(board: board)
            self.checkedKing = checkedKing
            self.possibleSquaresInCheck = possibleSquaresInCheck
            if let checkedKing = checkedKing {

                if possibleSquares(for: checkedKing, board: board).isEmpty, possibleSquaresInCheck.isEmpty {
                    move.checkMate = true
                } else {
                    move.check = true
                }
            } else {
                move.stalemate = checkForStalemate()
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

                if possibleSquares(for: index, board: board).contains(to) && index != from {
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

    func checkForStalemate() -> Bool {
        var possibleSquares = [Int]()
        for (index, piece) in board.enumerated() {
            if let piece = piece, piece.colour == currentPlayer {
                possibleSquares += self.possibleSquares(for: index, board: board)
            }
        }

        return possibleSquares.isEmpty
    }

    func checkForCheck(board: [Piece?]) -> (checkedKing: Int?, possibleSquaresInCheck: [Int]) {
        var possibleSquaresInCheck = [Int]()
        var checkedKing: Int?

        var checked = false
        for (index, piece) in board.enumerated() {
            if let piece = piece as? King {
                for (possibleIndex, horsey) in board.enumerated() {
                    if possibleIndex >= 0,
                        possibleIndex < board.count,
                        let possiblePiece = horsey,
                        possiblePiece.colour != piece.colour {
                        let possibleSquares = self.possibleSquares(for: possibleIndex, board: board, preventRecursion: true)
                        if possibleSquares.contains(index) {
                            checkedKing = index
                            checked = true
                            if possibleSquaresInCheck.isEmpty {
                                possibleSquaresInCheck += blockCheckSquares(kingIndex: index, checkedBy: possibleIndex)
                            } else {
                                possibleSquaresInCheck = possibleSquaresInCheck.filter(blockCheckSquares(kingIndex: index, checkedBy: possibleIndex).contains)
                            }
                        }
                    }
                }
            }
        }
        if let checkedKingIndex = checkedKing, let checkedKing = board[checkedKingIndex] as? King {
            var allPossibleBlockMoves = [Int]()
            for (index, piece) in board.enumerated() {
                if piece?.colour == checkedKing.colour, !(piece is King) {
                    allPossibleBlockMoves += possibleSquaresInCheck.filter(self.possibleSquares(for: index, board: board, preventRecursion: true).contains)
                }
            }
            possibleSquaresInCheck = possibleSquaresInCheck.filter(allPossibleBlockMoves.contains)

        }
        if checked {
            return (checkedKing: checkedKing, possibleSquaresInCheck: possibleSquaresInCheck)
        }
        checkedKing = nil
        return (checkedKing: nil, possibleSquaresInCheck: possibleSquaresInCheck)
    }

    func blockCheckSquares(kingIndex: Int, checkedBy: Int) -> [Int] {
        let kingSquare = Square(withIndex: kingIndex)
        let checkedBySquare = Square(withIndex: checkedBy)

        var direction: Int
        if kingSquare.file == checkedBySquare.file {
            direction = 8
        } else if kingSquare.rank == checkedBySquare.rank {
            direction = 1
        } else if (kingIndex - checkedBy) % 9 == 0 {
            direction = 9
        } else {
            direction = 7
        }

        if kingIndex-checkedBy < 0 {
            direction /= -1
        }

        print("block squares: ")
        print(direction)
        var blockCheckSquares = [Int]()
        if board[checkedBy] is Knight {
            blockCheckSquares.append(checkedBy)
        } else {
            for i in 1...(kingIndex-checkedBy)/direction {
                print(i)
                print(kingIndex-i*direction)
                blockCheckSquares.append(kingIndex-i*direction)
            }
        }
        print("\n\n")
        return blockCheckSquares
    }

    func promotePawn(to piece: Piece) {
        if let promotingPawn = promotingPawn {
            board[promotingPawn] = piece
            self.promotingPawn = nil

            let (checkedKing, possibleSquaresInCheck) = checkForCheck(board: board)
            self.checkedKing = checkedKing
            self.possibleSquaresInCheck = possibleSquaresInCheck
            if let checkedKing = checkedKing {
                gameLog.promoted(to: piece, check: true)

                if possibleSquares(for: checkedKing, board: board).isEmpty, possibleSquaresInCheck.isEmpty {
                    gameLog.promoted(to: piece, checkMate: true)
                }
            } else {
                gameLog.promoted(to: piece)
            }
        }
    }
}

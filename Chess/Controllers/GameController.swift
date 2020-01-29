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

    func possibleSquares(for index: Int) -> [Int] {
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
                let piecePosition = position(from: index)
                let possiblePosition = position(from: possibleSquare)
                if let piece = piece as? Knight, piece.validPossibleSquare(possiblePosition, position: piecePosition) {
                    if let possiblePiece = board[possibleSquare], possiblePiece.colour == piece.colour {
                        break
                    }
                    possibleSquares.append(possibleSquare)
                    if board[possibleSquare] != nil {
                        break
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
        guard from > 0, to > 0, from < board.count, to < board.count else {
            return
        }

        let piece = board[from]
        board[from] = nil
        if var pawn = piece as? Pawn {
            pawn.firstMove = false
            board[to] = pawn
        } else {
            board[to] = piece
        }
    }

    func row(from index: Int) -> Int {
        return index / 8
    }

    func column(from index: Int) -> Int {
        return index % 8
    }

    func position(from index: Int) -> (column: Int, row: Int) {
        return (column(from: index), row(from: index))
    }
}

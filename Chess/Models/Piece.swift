//
//  Piece.swift
//  Chess
//
//  Created by Tim Colla on 01/03/2019.
//  Copyright © 2019 Marino Software. All rights reserved.
//

import Foundation

/// What side the piece belongs to
enum Colour {
    case white
    case black

    func toggled() -> Colour {
        if self == .white {
            return .black
        } else {
            return .white
        }
    }
}

/// Piece protocol for all pieces to conform to
protocol Piece {
    /// Where a piece can mvoe
    var relativeMoves: [Int] { get }
    /// How far a piece can move
    var range: Int { get }
    /// What side a piece belongs to
    var colour: Colour { get }
    /// String value for displaying on the board
    var stringValue: String { get }
    /// Algebraic notation string value
    var algebraicNotation: String { get }

    init(colour: Colour)
}

struct Pawn: Piece {
    var colour: Colour
    var firstMove: Bool = true
    var relativeMoves: [Int] {
        return colour == .white ? [-8] : [8]
    }
    var range: Int {
        return firstMove ? 2 : 1
    }
    var takes: [Int] {
        return colour == .white ? [-7,-9] : [7,9]
    }

    var stringValue: String {
        return colour == .white ? "♙" : "♟"
    }

    var algebraicNotation: String {
        return ""
    }

    init(colour: Colour) {
        self.colour = colour
    }
}

struct Bishop: Piece {
    var colour: Colour
    var relativeMoves: [Int] = [-7,-9,7,9]
    var range: Int = 7

    var stringValue: String {
        return colour == .white ? "♗" : "♝"
    }

    var algebraicNotation: String {
        return "B"
    }

    init(colour: Colour) {
        self.colour = colour
    }
}

struct Queen: Piece {
    var colour: Colour
    var relativeMoves: [Int] = [-1,-7,-8,-9,1,7,8,9]
    var range: Int = 7

    var stringValue: String {
        return colour == .white ? "♕" : "♛"
    }

    var algebraicNotation: String {
        return "Q"
    }

    init(colour: Colour) {
        self.colour = colour
    }
}

struct King: Piece {
    var colour: Colour
    var firstMove: Bool = true
    var relativeMoves: [Int] {
        return firstMove ? [-1,-2,-7,-8,-9,1,2,7,8,9] : [-1,-7,-8,-9,1,7,8,9]
    }
    var range: Int = 1

    var stringValue: String {
        return colour == .white ? "♔" : "♚"
    }

    var algebraicNotation: String {
        return "K"
    }

    init(colour: Colour) {
        self.colour = colour
    }
}

struct Rook: Piece {
    var colour: Colour
    var firstMove: Bool = true
    var relativeMoves: [Int] = [-1,-8,1,8]
    var range: Int = 7

    var stringValue: String {
        return colour == .white ? "♖" : "♜"
    }

    var algebraicNotation: String {
        return "R"
    }

    init(colour: Colour) {
        self.colour = colour
    }
}

struct Knight: Piece {
    var colour: Colour
    var relativeMoves: [Int] = [-6,-10,-15,-17,6,10,15,17]
    var range: Int = 1

    var stringValue: String {
        return colour == .white ? "♘" : "♞"
    }

    var algebraicNotation: String {
        return "N"
    }

    init(colour: Colour) {
        self.colour = colour
    }

    func validPossibleSquare(_ possible: Square, position: Square) -> Bool {
        if position.coordinate.row - possible.coordinate.row >= -2 && position.coordinate.row - possible.coordinate.row <= 2
            && position.coordinate.column - possible.coordinate.column >= -2 && position.coordinate.column - possible.coordinate.column <= 2
            && possible.coordinate.column + possible.coordinate.row * 8 >= 0
            && possible.coordinate.column + possible.coordinate.row * 8 < 8 * 8 {
            return true
        }
        return false
    }
}

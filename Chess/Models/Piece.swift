//
//  Piece.swift
//  Chess
//
//  Created by Tim Colla on 01/03/2019.
//  Copyright © 2019 Marino Software. All rights reserved.
//

import Foundation

enum Colour {
    case white
    case black
}

typealias Position = (column: Int, row: Int)

protocol Piece {
    var relativeMoves: [Int] { get }
    var range: Int { get }
    var colour: Colour { get }
    var stringValue: String { get }

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

    init(colour: Colour) {
        self.colour = colour
    }
}

struct King: Piece {
    var colour: Colour
    var relativeMoves: [Int] = [-1,-7,-8,-9,1,7,8,9]
    var range: Int = 1

    var stringValue: String {
        return colour == .white ? "♔" : "♚"
    }

    init(colour: Colour) {
        self.colour = colour
    }
}

struct Rook: Piece {
    var colour: Colour
    var relativeMoves: [Int] = [-1,-8,1,8]
    var range: Int = 7

    var stringValue: String {
        return colour == .white ? "♖" : "♜"
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

    init(colour: Colour) {
        self.colour = colour
    }

    func validPossibleSquare(_ possible: Position, position: Position) -> Bool {
        if position.row - possible.row >= -2 && position.row - possible.row <= 2
            && position.column - possible.column >= -2 && position.column - possible.column <= 2
            && possible.column + possible.row * 8 >= 0
            && possible.column + possible.row * 8 < 8 * 8 {
            return true
        }
        return false
    }
}

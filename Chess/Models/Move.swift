//
//  Move.swift
//  Chess
//
//  Created by Tim Colla on 30/01/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import Foundation

/** Represents any move played
 */
struct Move {
    /// Piece that was moved
    let piece: Piece
    /// From where the piece moved
    let from: Int
    /// To where the piece moved
    let to: Int
    /// Whether it was a capture
    var capture: Bool = false
    /// Whether the move resulted in a check
    var check: Bool = false
    /// Whether the move resulted in a checkmate
    var checkMate: Bool = false
    /// Whether more than one of the same piece were possible and on the same file
    var ambiguousFile: Bool = false
    /// Whether more than one of the same piece were possible and on the same rank
    var ambiguousRank: Bool = false
    /// What type of castling move this was
    var castle: Castle?
}

/** Denotes a short (king side) or long (queen side) castle
 */
enum Castle: String, CustomStringConvertible {
    case short = "0-0"
    case long = "0-0-0"

    var description: String {
        return "\(rawValue)"
    }
}

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
struct Move: Codable {
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
    /// Whether the move resulted in a draw (stalemate, no checkmate possible, etc.)
    var draw: Bool = false
    /// Whether more than one of the same piece were possible and on the same file
    var ambiguousFile: Bool = false
    /// Whether more than one of the same piece were possible and on the same rank
    var ambiguousRank: Bool = false
    /// What type of castling move this was
    var castle: Castle?
    /// What piece a Pawn promoted to
    var promotedTo: Piece?

    init(piece: Piece, from: Int, to: Int, castle: Castle) {
        self.piece = piece
        self.from = from
        self.to = to
        self.castle = castle
    }

    init(piece: Piece, from: Int, to: Int, ambiguousFile: Bool, ambiguousRank: Bool) {
        self.piece = piece
        self.from = from
        self.to = to
        self.ambiguousFile = ambiguousFile
        self.ambiguousRank = ambiguousRank
    }

    enum CodingKeys: String, CodingKey {
        case piece, from, to, capture, check, checkMate, draw, ambiguousFile, ambiguousRank, castle, promotedTo
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        var piece: Piece
        do {
            piece = try values.decode(Pawn.self, forKey: .piece)
            if let possibleKing = piece as? Pawn {

                if (possibleKing.algebraicNotation == "K") {
                    piece = try values.decode(King.self, forKey: .piece)
                }
            }
        }
        catch {
            do {
                piece = try values.decode(King.self, forKey: .piece)
            }
            catch {
                do {
                    piece = try values.decode(Rook.self, forKey: .piece)
                }
                catch {
                    piece = try values.decode(Bishop.self, forKey: .piece)

                    if piece.algebraicNotation == "Q" {
                        piece = try values.decode(Queen.self, forKey: .piece)
                    } else if piece.algebraicNotation == "N" {
                        piece = try values.decode(Knight.self, forKey: .piece)
                    }
                }
            }
        }

        self.piece = piece

        from = try values.decode(Int.self, forKey: .from)
        to = try values.decode(Int.self, forKey: .to)
        capture = try values.decode(Bool.self, forKey: .capture)
        check = try values.decode(Bool.self, forKey: .check)
        checkMate = try values.decode(Bool.self, forKey: .checkMate)
        draw = try values.decode(Bool.self, forKey: .draw)
        ambiguousFile = try values.decode(Bool.self, forKey: .ambiguousFile)
        ambiguousRank = try values.decode(Bool.self, forKey: .ambiguousRank)
        castle = try values.decode(Castle?.self, forKey: .castle)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let piece = piece as? Pawn {
            try container.encode(piece, forKey: .piece)
        }
        else if let piece = piece as? Bishop {
            try container.encode(piece, forKey: .piece)
        }
        else if let piece = piece as? Queen {
            try container.encode(piece, forKey: .piece)
        }
        else if let piece = piece as? King {
            try container.encode(piece, forKey: .piece)
        }
        else if let piece = piece as? Rook {
            try container.encode(piece, forKey: .piece)
        }
        else if let piece = piece as? Knight {
            try container.encode(piece, forKey: .piece)
        }

        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(capture, forKey: .capture)
        try container.encode(check, forKey: .check)
        try container.encode(checkMate, forKey: .checkMate)
        try container.encode(draw, forKey: .draw)
        try container.encode(ambiguousFile, forKey: .ambiguousFile)
        try container.encode(ambiguousRank, forKey: .ambiguousRank)
        try container.encode(castle, forKey: .castle)
    }
}

/** Denotes a short (king side) or long (queen side) castle
 */
enum Castle: String, Codable, CustomStringConvertible {
    case short = "0-0"
    case long = "0-0-0"

    var description: String {
        return "\(rawValue)"
    }
}

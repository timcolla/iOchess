//
//  Helper.swift
//  ChessTests
//
//  Created by Tim Colla on 21/03/2021.
//  Copyright © 2021 Marino Software. All rights reserved.
//

import Foundation
@testable import Chess

struct Helper {
    static var standardBoard: [Piece?] {
        get {
        return [Rook(colour: .black), Knight(colour: .black), Bishop(colour: .black), Queen(colour: .black), King(colour: .black), Bishop(colour: .black), Knight(colour: .black), Rook(colour: .black),
                                   Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black),
                                   nil, nil, nil, nil, nil, nil, nil, nil,
                                   nil, nil, nil, nil, nil, nil, nil, nil,
                                   nil, nil, nil, nil, nil, nil, nil, nil,
                                   nil, nil, nil, nil, nil, nil, nil, nil,
                                   Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white),
                                   Rook(colour: .white), Knight(colour: .white), Bishop(colour: .white), Queen(colour: .white), King(colour: .white), Bishop(colour: .white), Knight(colour: .white), Rook(colour: .white)]
        }
    }
}

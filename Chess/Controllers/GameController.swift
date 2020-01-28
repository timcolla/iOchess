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

    init() {
        var movedPawnBlack = Pawn(colour: .black)
        movedPawnBlack.firstMove = false
        var movedPawnWhite = Pawn(colour: .white)
        movedPawnWhite.firstMove = false
        board = [Rook(colour: .black), Knight(colour: .black), Bishop(colour: .black), Queen(colour: .black), King(colour: .black), Bishop(colour: .black), Knight(colour: .black), Rook(colour: .black),
                 Pawn(colour: .black), Pawn(colour: .black), nil, Pawn(colour: .black), nil, Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black),
                 nil, nil, movedPawnBlack, nil, movedPawnBlack, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, nil, nil, nil, nil, nil, nil, nil,
                 nil, movedPawnWhite, nil, nil, movedPawnWhite, nil, nil, nil,
                 Pawn(colour: .white), nil, Pawn(colour: .white), Pawn(colour: .white), nil, Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white),
                 Rook(colour: .white), Knight(colour: .white), Bishop(colour: .white), Queen(colour: .white), King(colour: .white), Bishop(colour: .white), Knight(colour: .white), Rook(colour: .white)]
    }
}

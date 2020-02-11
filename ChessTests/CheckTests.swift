//
//  CheckTests.swift
//  ChessTests
//
//  Created by Tim Colla on 10/02/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import XCTest
@testable import Chess

class CheckTests: XCTestCase {

    let board: [Piece?] = [nil, nil, nil, nil, King(colour: .black), nil, nil, nil,
                           nil, nil, nil, nil, Pawn(colour: .black), nil, nil, nil,
                           nil, nil, nil, nil, Queen(colour: .white), Bishop(colour: .white), nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil,
    Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white),
    Rook(colour: .white), Knight(colour: .white), Bishop(colour: .white), nil, King(colour: .white), nil, Knight(colour: .white), Rook(colour: .white)]
    let gc = GameController()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        gc.board = board
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheck() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        gc.selectSquare(index: 20)
        gc.selectSquare(index: 2)

        guard let lastMove = gc.gameLog.moves.last else {
            XCTAssert(false)
            return
        }

        XCTAssert(lastMove.check)
        XCTAssert(!lastMove.checkMate)
        XCTAssert(!lastMove.stalemate)
    }

}

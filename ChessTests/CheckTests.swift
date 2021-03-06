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
                           nil, Knight(colour: .black), nil, nil, Pawn(colour: .black), nil, nil, nil,
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
        XCTAssert(!lastMove.draw)
    }

    func testBlockCheck() {
        testCheck()

        let possibleSquares = gc.possibleSquares(for: 9, board: gc.board)
        XCTAssert(possibleSquares.count == 1)
        XCTAssert(possibleSquares.contains(3))

        // Move Knight to block check
        gc.selectSquare(index: 9)
        gc.selectSquare(index: 3)

        XCTAssert(gc.board[3] is Knight)
    }

    func testMoveKingOutOfCheck() {
        testCheck()

        let possibleSquares = gc.possibleSquares(for: 4, board: gc.board)
        XCTAssert(possibleSquares.count == 1)
        XCTAssert(possibleSquares.contains(13))

        gc.selectSquare(index: 4)
        gc.selectSquare(index: 13)

        XCTAssert(gc.board[13] is King)
    }

    /// This test tries to move a piece that blocks an opponent's piece from checking the King,
    /// so not allowed to be moved unless it also blocks a check
    func testMoveCheckBlockingPiece() {
        testCheck()

        // Move Knight to block check
        gc.selectSquare(index: 9)
        gc.selectSquare(index: 3)

        XCTAssert(gc.board[3] is Knight)

        // Move Queen one square
        gc.selectSquare(index: 2)
        gc.selectSquare(index: 1)

        XCTAssert(gc.currentPlayer == .black)

        let possibleSquares = gc.possibleSquares(for: 3, board: gc.board)
        XCTAssert(possibleSquares.count == 0)
    }

    func testKingTakeResultingInCheck() {
        // Bishop capture Pawn
        gc.selectSquare(index: 21)
        gc.selectSquare(index: 12)

        XCTAssert(gc.board[12] is Bishop)
        XCTAssert(gc.board[4] is King)
        XCTAssert(!gc.possibleSquares(for: 4, board: board).contains(12))
    }
}

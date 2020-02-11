//
//  ChessTests.swift
//  ChessTests
//
//  Created by Tim Colla on 30/01/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import XCTest
@testable import Chess

class ChessTests: XCTestCase {

    var board: [Piece?] = [Rook(colour: .black), Knight(colour: .black), Bishop(colour: .black), Queen(colour: .black), King(colour: .black), Bishop(colour: .black), Knight(colour: .black), Rook(colour: .black),
    Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black), Pawn(colour: .black),
    nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil,
    Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white), Pawn(colour: .white),
    Rook(colour: .white), Knight(colour: .white), Bishop(colour: .white), Queen(colour: .white), King(colour: .white), Bishop(colour: .white), Knight(colour: .white), Rook(colour: .white)]

    let gc = GameController()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        gc.board = board
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPawnMove() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        gc.selectSquare(index: 53)
        gc.selectSquare(index: 45)

        XCTAssert(gc.board[53] == nil)
        XCTAssert(gc.board[45] is Pawn)
    }

    func testTurnBased() {
        // White Pawn
        gc.selectSquare(index: 53)
        gc.selectSquare(index: 45)

        // Select Black Pawn, but don't move
        gc.selectSquare(index: 9)
        XCTAssert(gc.selectedSquare == 9)

        // Still Black's turn, try to select White Pawn
        gc.selectSquare(index: 45)
        XCTAssert(gc.selectedSquare == nil)
    }

    func testEnPassant() {
        board[33] = Pawn(colour: .white)
        gc.board = board

        // Move white Pawn 1 square
        gc.selectSquare(index: 33)
        gc.selectSquare(index: 25)

        // Move black Pawn 2 squares
        gc.selectSquare(index: 8)
        gc.selectSquare(index: 24)

        XCTAssert(gc.enPassantablePawn == 24)

        // Take Pawn en passant
        gc.selectSquare(index: 25)
        gc.selectSquare(index: 16)

        XCTAssert(gc.board[24] == nil)
        XCTAssert((gc.board[16] as! Pawn).colour == .white)
    }
}

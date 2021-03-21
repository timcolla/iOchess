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

    var testBoard: [Piece?]!
    var gc: GameController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testBoard = Helper.standardBoard
        gc = GameController()
        gc.board = testBoard
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        testBoard = nil
        gc = nil
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
        testBoard[33] = Pawn(colour: .white)
        gc.board = testBoard

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

    func testEnPassantNotAllowed() {
        testBoard[41] = Pawn(colour: .white)
        gc.board = testBoard

        // Move white Pawn 1 square
        gc.selectSquare(index: 41)
        gc.selectSquare(index: 33)

        // Move black Pawn 1 square
        gc.selectSquare(index: 8)
        gc.selectSquare(index: 16)

        // Move white Pawn 1 square
        gc.selectSquare(index: 33)
        gc.selectSquare(index: 25)

        // Move Black Pawn 1 square
        gc.selectSquare(index: 16)
        gc.selectSquare(index: 24)

        // Try to take en passant
        gc.selectSquare(index: 25)
        gc.selectSquare(index: 16)

        XCTAssert(gc.board[24] != nil)
        XCTAssert(gc.board[16] == nil)
        XCTAssert((gc.board[25] as! Pawn).colour == .white)
        XCTAssert((gc.board[24] as! Pawn).colour == .black)
    }

    func testPromotePawn() {
        testBoard[7] = nil
        testBoard[15] = Pawn(colour: .white)
        gc.board = testBoard

        gc.selectSquare(index: 15)
        gc.selectSquare(index: 7)

        gc.promotePawn(to: Queen(colour: .white))

        XCTAssert(gc.board[15] == nil)
        XCTAssert(gc.board[7] is Queen)
    }
}

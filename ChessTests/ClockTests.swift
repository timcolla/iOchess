//
//  ClockTests.swift
//  ChessTests
//
//  Created by Tim Colla on 13/02/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import XCTest
@testable import Chess

class ClockTests: XCTestCase {

    let gc = GameController()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimeToString() {
        let clock = gc.clock

        XCTAssert(clock.timeString(from: clock.blackTime) == "5:00")

        clock.blackTime -= 7
        XCTAssert(clock.timeString(from: clock.blackTime) == "4:53")

        clock.blackTime -= 52
        XCTAssert(clock.timeString(from: clock.blackTime) == "4:01")

        clock.blackTime -= (3*60)+55
        XCTAssert(clock.timeString(from: clock.blackTime) == "0:06")
    }

}

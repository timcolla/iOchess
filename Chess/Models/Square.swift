//
//  Square.swift
//  Chess
//
//  Created by Tim Colla on 31/01/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import Foundation

struct Square {
    typealias Coordinate = (column: Int, row: Int)

    private let index: Int
    var coordinate: Coordinate {
        get {
            return Coordinate(column: column(from: index), row: row(from: index))
        }
    }

    init(withIndex index: Int) {
        self.index = index
    }

    /// Returns the coordinate in an Algebraic notation string
    func toAN() -> String {
        let columns = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let row = 8-coordinate.row

        return columns[coordinate.column]+"\(row)"
    }

    func row(from index: Int) -> Int {
        return index / 8
    }

    func column(from index: Int) -> Int {
        return index % 8
    }
}

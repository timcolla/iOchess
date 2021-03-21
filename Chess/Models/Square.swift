//
//  Square.swift
//  Chess
//
//  Created by Tim Colla on 31/01/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import Foundation

/** Denotes a square on the board
 */
struct Square {
    typealias Coordinate = (column: Int, row: Int)

    private let index: Int
    /// The coordinate of this square
    var coordinate: Coordinate {
        get {
            return Coordinate(column: column(from: index), row: row(from: index))
        }
    }

    /// The file this square is in
    var file: String {
        get {
            let columns = ["a", "b", "c", "d", "e", "f", "g", "h"]
            return columns[coordinate.column]
        }
    }

    /// The rank this square is in
    var rank: String {
        get {
            return String(8-coordinate.row)
        }
    }

    /** Initialise with an array index

         Indexes go from 0-63
     */
    init(withIndex index: Int) {
        self.index = index
    }

    /// Returns the coordinate in an Algebraic notation string
    func toAN() -> String {
        let columns = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let row = 8-coordinate.row

        return columns[coordinate.column]+"\(row)"
    }

    private func row(from index: Int) -> Int {
        return index / 8
    }

    private func column(from index: Int) -> Int {
        return index % 8
    }
}

//
//  Move.swift
//  Chess
//
//  Created by Tim Colla on 30/01/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import Foundation

struct Move {
    let piece: Piece
    let from: Int
    let to: Int
    var capture: Bool = false
    var check: Bool = false
    var checkMate: Bool = false
    var ambiguousFile: Bool = false
    var ambiguousRank: Bool = false
}

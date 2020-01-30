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
    let capture: Bool = false
    let check: Bool = false
    let checkMate: Bool = false
}

//
//  NotificationName+Chess.swift
//  Chess
//
//  Created by Tim Colla on 07/02/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let onPromotePawn = Notification.Name("onPromotePawn")
    static let onClockChange = Notification.Name("onClockChange")
    static let lostOnTime = Notification.Name("lostOnTime")
    static let replayMoves = Notification.Name("replayMoves")
}

struct Promotion {
    let index: Int
    let colour: Colour
}

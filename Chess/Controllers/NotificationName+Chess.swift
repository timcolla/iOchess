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
}

struct Promotion {
    let index: Int
    let colour: Colour
}

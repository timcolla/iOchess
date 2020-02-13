//
//  Clock.swift
//  Chess
//
//  Created by Tim Colla on 13/02/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import Foundation

class Clock {
    var time: Int
    var blackTime: Int
    var whiteTime: Int

    var timer: Timer?

    init(withTime time: Int = 60 * 5) {
        self.time = time
        blackTime = time
        whiteTime = time
    }

    func start(for player: Colour) {
        timer?.invalidate()
        timer = nil

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            switch player {
            case .black:
                self.blackTime -= 1
            case .white:
                self.whiteTime -= 1
            }

            NotificationCenter.default.post(name: .onClockChange,
                                            object: nil,
                                            userInfo: [Colour.black: self.blackTime,
                                                       Colour.white: self.whiteTime])
        })
    }

    func reset() {
        timer?.invalidate()
        timer = nil

        blackTime = time
        whiteTime = time

        NotificationCenter.default.post(name: .onClockChange,
                                        object: nil,
                                        userInfo: [Colour.black: self.blackTime,
                                                   Colour.white: self.whiteTime])
    }
}

//
//  LogRow.swift
//  Chess
//
//  Created by Tim Colla on 06/02/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import UIKit

class LogView: UIStackView {
    func showGameLog(_ gameLog: GameLog) {
        for arrangedSubView in arrangedSubviews {
            arrangedSubView.removeFromSuperview()
        }
//        print(gameLog.toAN())

        for row in gameLog.toAN() {
            let moveNumber = UILabel()
            moveNumber.textAlignment = .center
            moveNumber.text = "\(row.0)"
            let moveWhite = UILabel()
            moveWhite.text = row.1
            let moveBlack = UILabel()
            moveBlack.text = row.2
            let row = UIStackView(arrangedSubviews: [moveNumber, moveWhite, moveBlack])
            row.distribution = .fillEqually
            row.axis = .horizontal
            addArrangedSubview(row)
        }
    }
}

//
//  LogRow.swift
//  Chess
//
//  Created by Tim Colla on 06/02/2020.
//  Copyright © 2020 Marino Software. All rights reserved.
//

import UIKit

class LogView: UIScrollView {
    @IBOutlet weak var stackView: UIStackView!

    func showGameLog(_ gameLog: GameLog) {
        for arrangedSubView in stackView.arrangedSubviews {
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
            stackView.addArrangedSubview(row)
        }

        layoutIfNeeded()
        if contentSize.height > bounds.size.height + contentInset.bottom {
            let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
            setContentOffset(bottomOffset, animated: false)
        }
    }
}

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
    var gameLog: GameLog?

    func showGameLog(_ gameLog: GameLog) {
        self.gameLog = gameLog

        for arrangedSubView in stackView.arrangedSubviews {
            arrangedSubView.removeFromSuperview()
        }

        for (index, row) in gameLog.toAN().enumerated() {
            let moveNumber = UILabel()
            moveNumber.textAlignment = .center
            moveNumber.text = "\(row.0)"

            let moveWhite = UILabel()
            moveWhite.text = row.1
            moveWhite.tag = index * 2
            moveWhite.isUserInteractionEnabled = true

            let tapGestureWhite = UITapGestureRecognizer(target: self, action: #selector(replayMove))
            moveWhite.addGestureRecognizer(tapGestureWhite)

            let moveBlack = UILabel()
            moveBlack.text = row.2
            moveBlack.tag = index * 2 + 1
            moveBlack.isUserInteractionEnabled = true

            let tapGestureBlack = UITapGestureRecognizer(target: self, action: #selector(replayMove))
            moveBlack.addGestureRecognizer(tapGestureBlack)

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

    @objc func replayMove(gestureRecognizer: UIGestureRecognizer) {
        if let moveView = gestureRecognizer.view, let gameLog = gameLog {
            var moves = [Move]()
            for i in 0...moveView.tag {
                moves.append(gameLog.moves[i])
            }

            NotificationCenter.default.post(name: .replayMoves, object: nil, userInfo: ["moves": moves])
        }
    }
}

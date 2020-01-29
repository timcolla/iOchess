//
//  ViewController.swift
//  Chess
//
//  Created by Tim Colla on 01/03/2019.
//  Copyright © 2019 Marino Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let gc = GameController()

    var squareViews: [SquareView] = [SquareView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        drawBoard()
    }

    func drawBoard() {
        let size = 30
        for i in 0..<gc.board.count {
            let view = SquareView(frame: CGRect(x: 100 + (i % 8) * size - 1 * (i % 8), y: 100 + i/8 * size - 1 * (i / 8), width: size, height: size))
            view.layer.borderColor = UIColor.red.cgColor
            view.layer.borderWidth = 1

            let label = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
            label.text = gc.board[i]?.stringValue
            view.label = label
            view.addSubview(label)

            view.tag = i
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSquare(_:))))
            view.piece = gc.board[i]

            self.view.addSubview(view)
            self.squareViews.append(view)
        }

        colourCheckers()
    }

    func updateBoard() {
        for i in 0..<gc.board.count {
            let view = squareViews[i]
            view.label.text = gc.board[i]?.stringValue
            view.piece = gc.board[i]
        }
    }

    @objc func tapSquare(_ recogniser: UITapGestureRecognizer) {
        if let view = recogniser.view as? SquareView {
            gc.selectSquare(index: view.tag)
            updateBoard()

            if gc.selectedSquare != nil {
                showPossibleSquares(for: view.tag)
            } else {
                colourCheckers()
            }
        }
    }

    func colourCheckers() {
        for i in 0..<squareViews.count {
            if i / 8 % 2 == 0 {
                squareViews[i].backgroundColor = i % 2 == 0 ? .white : .gray
            } else {
                squareViews[i].backgroundColor = i % 2 == 1 ? .white : .gray
            }
        }
    }

    func showPossibleSquares(for index: Int) {
        // reset
        colourCheckers()
        squareViews[index].backgroundColor = .yellow

        let possibleSquares = gc.possibleSquares(for: index)
        for possibleSquare in possibleSquares {
            squareViews[possibleSquare].backgroundColor = .blue
        }
    }

}

class SquareView: UIView {
    var piece: Piece? {
        didSet {
            label.text = piece?.stringValue
        }
    }
    var label: UILabel!
}

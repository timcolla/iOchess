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

    @IBOutlet weak var logView: LogView!
    var squareViews: [SquareView] = [SquareView]()
    var promotingViews: [SquareView] =  [SquareView]()

    @IBOutlet weak var timeBlack: UILabel!
    @IBOutlet weak var timeWhite: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        NotificationCenter.default.addObserver(self, selector: #selector(promotePawn(_:)), name: .onPromotePawn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clockUpdate(_:)), name: .onClockChange, object: nil)

        drawBoard()
        logView.showGameLog(gc.gameLog)

        timeBlack.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        timeBlack.text = gc.clock.timeString(from: gc.clock.blackTime)
        timeWhite.text = gc.clock.timeString(from: gc.clock.whiteTime)
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

    @IBAction func reset(_ sender: Any) {
        squareViews = [SquareView]()
        gc.reset()
        drawBoard()
        logView.showGameLog(gc.gameLog)
    }

    @objc func tapSquare(_ recogniser: UITapGestureRecognizer) {
        if let view = recogniser.view as? SquareView {
            gc.selectSquare(index: view.tag)
            logView.showGameLog(gc.gameLog)
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

        let possibleSquares = gc.possibleSquares(for: index, board: gc.board)
        for possibleSquare in possibleSquares {
            squareViews[possibleSquare].backgroundColor = .blue
        }
    }

    @objc func promotePawn(_ notification:Notification) {
        if let promotion = notification.object as? Promotion {
            let pawnIndex = promotion.index
            let colour = promotion.colour
            let promotions: [Piece] = [Queen(colour: colour), Bishop(colour: colour), Knight(colour: colour), Rook(colour: colour)]
            let size = 30
            for (i, piece) in promotions.enumerated() {
                let direction = colour == .white ? 8 : -8
                let index = pawnIndex + direction*i
                let view = SquareView(frame: CGRect(x: 100 + (index % 8) * size - 1 * (index % 8), y: 100 + index/8 * size - 1 * (index / 8), width: size, height: size))
                view.layer.borderColor = UIColor.red.cgColor
                view.layer.borderWidth = 1

                let label = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
                label.text = piece.stringValue
                view.label = label
                view.addSubview(label)

                view.tag = i
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(promoteTo(_:))))
                view.piece = piece

                view.backgroundColor = .red

                self.view.addSubview(view)
                promotingViews.append(view)
            }
        }
    }

    @objc func promoteTo(_ recogniser: UITapGestureRecognizer) {
        if let view = recogniser.view as? SquareView, let piece = view.piece {
            gc.promotePawn(to: piece)
            logView.showGameLog(gc.gameLog)
            updateBoard()

            for view in promotingViews {
                view.removeFromSuperview()
            }
            promotingViews.removeAll()
        }
    }

    @objc func clockUpdate(_ notification: Notification) {
        guard let clock = notification.userInfo as? [Colour: String] else {
            print("Clock error")
            return
        }

        timeBlack.text = clock[.black]
        timeWhite.text = clock[.white]
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

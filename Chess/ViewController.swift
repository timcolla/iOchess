//
//  ViewController.swift
//  Chess
//
//  Created by Tim Colla on 01/03/2019.
//  Copyright © 2019 Marino Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var squareViews: [SquareView] = [SquareView]()
    var selectedSquare: SquareView? = nil
    var possibleSquares: [Int]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let gc = GameController()

        let size = 30
        for i in 0..<gc.board.count {
            let view = SquareView(frame: CGRect(x: 100 + (i % 8) * size - 1 * (i % 8), y: 100 + i/8 * size - 1 * (i / 8), width: size, height: size))
            view.layer.borderColor = UIColor.red.cgColor
            view.layer.borderWidth = 1
//            if i / 8 % 2 == 0 {
//                view.backgroundColor = i % 2 == 0 ? .white : .gray
//            } else {
//                view.backgroundColor = i % 2 == 1 ? .white : .gray
//            }
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

    @objc func tapSquare(_ recogniser: UITapGestureRecognizer) {
        if let view = recogniser.view as? SquareView {
            if let selectedSquare = selectedSquare, let possibleSquares = possibleSquares {
                if possibleSquares.contains(view.tag) {
                    view.piece = selectedSquare.piece
                    selectedSquare.piece = nil
                    colourCheckers()
                    self.selectedSquare = nil
                    self.possibleSquares = nil
                    return
                }
                self.selectedSquare = nil
                self.possibleSquares = nil
            }
            showPossibleSquares(for: view.tag)
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
        guard let piece = squareViews[index].piece else {
            return
        }
        squareViews[index].backgroundColor = .yellow

        let possibleSquares = self.possibleSquares(for: piece, index: index)
        for possibleSquare in possibleSquares {
            squareViews[possibleSquare].backgroundColor = .blue
        }
        self.selectedSquare = squareViews[index]
        self.possibleSquares = possibleSquares
    }

    func possibleSquares(for piece: Piece, index: Int) -> [Int] {
        var possibleSquares = [Int]()
        for relativeMove in piece.relativeMoves {
            for i in 1...piece.range {
                if index % 8 == 0 && (relativeMove == 7 || relativeMove == -9 || relativeMove == -1) {
                    break
                }
                if index % 8 == 7 && (relativeMove == -7 || relativeMove == 9 || relativeMove == 1) {
                    break
                }
                if index / 8 == 0 && (relativeMove == -7 || relativeMove == -9 || relativeMove == -8) {
                    break
                }
                if index / 8 == 7 && (relativeMove == 7 || relativeMove == 9 || relativeMove == 8) {
                    break
                }
                let possibleSquare = relativeMove * i + index
                let piecePosition = position(from: index)
                let possiblePosition = position(from: possibleSquare)
                if let piece = piece as? Knight, piece.validPossibleSquare(possiblePosition, position: piecePosition) {
                    if let possiblePiece = squareViews[possibleSquare].piece, possiblePiece.colour == piece.colour {
                        break
                    }
                    possibleSquares.append(possibleSquare)
                    if squareViews[possibleSquare].piece != nil {
                        break
                    }
                } else if possibleSquare >= 0 && possibleSquare < squareViews.count && !(piece is Knight) {
                    if let possiblePiece = squareViews[possibleSquare].piece, possiblePiece.colour == piece.colour {
                        break
                    }
                    possibleSquares.append(possibleSquare)
                    if squareViews[possibleSquare].piece != nil {
                        break
                    }
                }

                if possibleSquare % 8 == 0 && (relativeMove == 7 || relativeMove == -9 || relativeMove == -1) {
                    break
                }
                if possibleSquare % 8 == 7 && (relativeMove == -7 || relativeMove == 9 || relativeMove == 1) {
                    break
                }
                if possibleSquare / 8 == 0 && (relativeMove == 7 || relativeMove == -9 || relativeMove == -8) {
                    break
                }
                if possibleSquare / 8 == 7 && (relativeMove == -7 || relativeMove == 9 || relativeMove == 8) {
                    break
                }
            }
        }

        return possibleSquares
    }

    func row(from index: Int) -> Int {
        return index / 8
    }

    func column(from index: Int) -> Int {
        return index % 8
    }

    func position(from index: Int) -> (column: Int, row: Int) {
        return (column(from: index), row(from: index))
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

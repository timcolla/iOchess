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
    @IBOutlet weak var chessBoard: UIView!

    var shouldDrawBoard = true

    @IBOutlet weak var replayButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        NotificationCenter.default.addObserver(self, selector: #selector(promotePawn(_:)), name: .onPromotePawn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clockUpdate(_:)), name: .onClockChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(replayMoves(_:)), name: .replayMoves, object: nil)

        logView.showGameLog(gc.gameLog)

        timeBlack.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        timeBlack.text = gc.clock.timeString(from: gc.clock.blackTime)
        timeWhite.text = gc.clock.timeString(from: gc.clock.whiteTime)
    }

    override func viewDidLayoutSubviews() {

        if shouldDrawBoard {
            drawBoard()
            shouldDrawBoard = false
        }
    }

    func drawBoard() {
        for squareView in squareViews {
            squareView.removeFromSuperview()
        }
        squareViews.removeAll()

        chessBoard.layer.borderColor = UIColor.systemOrange.cgColor
        chessBoard.layer.borderWidth = 1
        chessBoard.backgroundColor = .clear

        let size = chessBoard.frame.width / 8.0

        for i in 0..<gc.board.count {
            let column = CGFloat(i % 8)
            let row = CGFloat(i / 8)
            let x = CGFloat(column) * size
            let y = CGFloat(row) * size
            let view = SquareView(frame: CGRect(x: x, y: y, width: size, height: size))

            let label = UILabel(frame: CGRect(x: 0, y: 0, width: size, height: size))
            label.text = gc.board[i]?.stringValue
            view.label = label
            view.addSubview(label)

            view.tag = i
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSquare(_:))))
            view.piece = gc.board[i]

            self.chessBoard.addSubview(view)
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
        shouldDrawBoard = true
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

    @objc func replayMoves(_ notification: Notification) {
        if !gc.playBack {
            return
        }
        guard let moves = notification.userInfo?["moves"] as? [Move],
            let label = notification.userInfo?["label"] as? UILabel else {
            print("Replay notification error")
            return
        }

        gc.resetBoard()

        for move in moves {
            gc.replayMove(from: move.from, to: move.to)
        }
        updateBoard()

        label.layer.backgroundColor = UIColor.orange.cgColor
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            label.layer.backgroundColor = UIColor.clear.cgColor
        }, completion: nil)
    }

    @IBAction func toggleReplay(_ sender: UIButton) {
        if gc.playBack {
            replayButton.setTitle("Replay Log", for: .normal)
        } else {
            replayButton.setTitle("Resume Game", for: .normal)
        }

        gc.playBack.toggle()
    }

    @IBAction func exportLog(_ sender: UIButton) {
        gc.stopGame()

        gc.gameLog.exportMoves { (file) in
            let items: [Any] = [file]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
        }
    }

    @IBAction func replaySharedLog(_ sender: UIButton) {
        if let chessData = UserDefaults(suiteName: "group.com.marinosoftware.chess")?.value(forKey: "chessData") as? Data {
            if let image = UIImage(data: chessData) {
                print(image)
            }
            if let moves = try? JSONDecoder().decode([Move].self, from: chessData) {
                gc.playBack = true
                gc.resetBoard()
                updateBoard()

                gc.gameLog.moves = moves
                logView.showGameLog(gc.gameLog)

                UserDefaults(suiteName: "group.com.marinosoftware.chess")?.removeObject(forKey: "chessData")
            }
        } else {
            print("No log was shared")
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.json"], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false

            self.present(documentPicker, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)

        guard let sourceUrl = urls.first,
            let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let destinationUrl = documentsDir.appendingPathComponent("Chess_log.json")

        do {
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                try FileManager.default.removeItem(at: destinationUrl)
            }
            try FileManager.default.copyItem(at: sourceUrl, to: destinationUrl)

            startGameFrom(file: destinationUrl)
        } catch {
            print(error)
        }
    }

    func startGameFrom(file: URL) {
        if let moves = try? JSONDecoder().decode([Move].self, from: Data(contentsOf: file)) {
            gc.playBack = true
            gc.resetBoard()
            updateBoard()

            gc.gameLog.moves = moves
            logView.showGameLog(gc.gameLog)

            UserDefaults(suiteName: "group.com.marinosoftware.chess")?.removeObject(forKey: "chessData")
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

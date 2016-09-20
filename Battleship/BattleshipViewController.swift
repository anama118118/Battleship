//
//  BattleshipViewController.swift
//  Battleship
//
//  Created by Jason Gresh on 9/16/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class BattleshipViewController: UIViewController {
    
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var gridView2: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    let brain: BattleshipBrain
    
    required init?(coder aDecoder: NSCoder) {
        self.brain = BattleshipBrain(rows: 5, columns: 5)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // better than viewDidLayoutSubviews but not all the way there
        self.view.layoutIfNeeded()
        
        startGame()
       // startGame2() //ideally, it will be seen in the bottom view
    }
    
    func buttonTappedToSetShip(_ sender: UIButton){
        let r = (sender.tag - 1) / brain.columns
        let c = (sender.tag - 1) % brain.columns
        
        _ = brain.set(atRow: r, andColumn: c) //set up for computer
        
        drawBoard(settingUp: true)
        
        if brain.gameSetUpComplete() {
            messageLabel.text = "Set up completed! Click ready to play!"
        }
        else {
            messageLabel.text = "Select more ships"
        }
    }
    
    func buttonTapped(_ sender: UIButton) {
        
        // our tag is one-based so we subtract 1 before indexing
        //horizontal, 0/5 to 4/5 will be on row 0
        let r = (sender.tag - 1) / brain.columns
        //vertical, remainder of 0/5 is 0 while remainder of 4/5 is 4, the remainder will be column number
        let c = (sender.tag - 1) % brain.columns
        
        // ??note how the strike itself isn't updating the interface
        _ = brain.strike(atRow: r, andColumn: c) //sender update
        
        // redraw the whole board
        drawBoard(settingUp: false)
        
        // check for win
        if brain.gameFinished() {
            messageLabel.text = "You win!"
        }
        else {
            messageLabel.text = "Keep guessing"
        }
    }
    
    func buttonTapped2(_ sender: UIButton) {
        
        // our tag is one-based so we subtract 1 before indexing
        //horizontal, 0/5 to 4/5 will be on row 0
        let r = (sender.tag - 1) / brain.columns
        //vertical, remainder of 0/5 is 0 while remainder of 4/5 is 4, the remainder will be column number
        let c = (sender.tag - 1) % brain.columns
        
        // ??note how the strike itself isn't updating the interface
        _ = brain.strike(atRow: r, andColumn: c) //sender update
        
        // redraw the whole board
        drawBoard2(settingUp: false)
        
        // check for win
        if brain.gameFinished() {
            messageLabel.text = "You win!"
        }
        else {
            messageLabel.text = "Keep guessing"
        }
    }
    
    func getButtonTabbed(_ sender: UIButton) {
        for _ in 0..<5 {
            let a = Int(arc4random_uniform(UInt32(brain.rows)))
            print(brain.rows)
            let b = Int(arc4random_uniform(UInt32(brain.columns)))
            print(brain.columns)
            
            //note how the strike itself isn't updating the interface
            _ = brain.strike(atRow: a, andColumn: b) //sender update
        }
        // redraw the whole board
        drawBoard(settingUp: false)
        // check for win
        if brain.gameFinished() {
            messageLabel.text = "Computer won!"
        }
        else {
            messageLabel.text = "Computer misses!"
        }
    }
    
    
    //MARK: 1Connect the the conditions of each button when .shown or .hidden
    func drawBoard(settingUp: Bool) {
        for r in 0..<brain.rows {
            for c in 0..<brain.columns {
                // find the button by tag
                // our tag is one-based so we add 1
                if let button = gridView.viewWithTag(r * brain.columns + c + 1) as? UIButton {
                    // funky subscript call with two indexes ([r][c] doesn't seem to work)
                    // switch the corresponding location by brain[r, c]
                    switch settingUp{
                    case true:
                        switch brain[r, c] {
                        case .empty(let state, _ ): //case .empty
                            switch state { //switch state of .empty
                            case .shown:
                                button.backgroundColor = UIColor.white
                            case .hidden:
                                button.backgroundColor = UIColor.black
                            }
                        case .occupied(let state, _): //case .occupied
                            switch state { //switch state of .occupied
                            case .shown:
                                button.backgroundColor = UIColor.red
                            case .hidden:
                                button.backgroundColor = UIColor.green
                            }
                        }
                    default:
                        switch brain[r, c] {
                        case .empty(let state, _ ): //case .empty
                            switch state { //switch state of .empty
                            case .shown: //case .empty.shown, button color will be lightGray
                                button.backgroundColor = UIColor.lightGray
                            case .hidden: //case .empty.hidden, button color will be blue
                                button.backgroundColor = UIColor.blue
                            }
                        case .occupied(let state, _): //case .occupied
                            switch state { //switch state of .occupied
                            case .shown: //case .occupied.shown, button color will be red
                                button.backgroundColor = UIColor.red
                            case .hidden: //case .occupied.hidden, button color will be blue
                                button.backgroundColor = UIColor.blue
                            }
                        }
                    }
                }
            }
        }
    }
    
    func drawBoard2(settingUp: Bool) {
        for r in 0..<brain.rows {
            for c in 0..<brain.columns {
                // find the button by tag
                // our tag is one-based so we add 1
                if let button = gridView2.viewWithTag(r * brain.columns + c + 1) as? UIButton {
                    // funky subscript call with two indexes ([r][c] doesn't seem to work)
                    // switch the corresponding location by brain[r, c]
                    switch settingUp{
                    case true:
                        switch brain[r, c] {
                        case .empty(let state, _ ): //case .empty
                            switch state { //switch state of .empty
                            case .shown:
                                button.backgroundColor = UIColor.white
                            case .hidden:
                                button.backgroundColor = UIColor.black
                            }
                        case .occupied(let state, _): //case .occupied
                            switch state { //switch state of .occupied
                            case .shown:
                                button.backgroundColor = UIColor.red
                            case .hidden:
                                button.backgroundColor = UIColor.green
                            }
                        }
                    default:
                        switch brain[r, c] {
                        case .empty(let state, _ ): //case .empty
                            switch state { //switch state of .empty
                            case .shown: //case .empty.shown, button color will be lightGray
                                button.backgroundColor = UIColor.lightGray
                            case .hidden: //case .empty.hidden, button color will be blue
                                button.backgroundColor = UIColor.blue
                            }
                        case .occupied(let state, _): //case .occupied
                            switch state { //switch state of .occupied
                            case .shown: //case .occupied.shown, button color will be red
                                button.backgroundColor = UIColor.red
                            case .hidden: //case .occupied.hidden, button color will be blue
                                button.backgroundColor = UIColor.blue
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: Set up the physical button in the UIView
    func setUpGameButtons(v: UIView, computerInputing: Bool) {
        // remove all views from the container
        // this helps both with resetting and if viewDidLayoutSubviews is called more than once
        for v in v.subviews {
            v.removeFromSuperview()
        }
        
        let side : CGFloat = v.bounds.size.width / CGFloat(brain.rows)
        for row in 0..<brain.rows {
            for col in 0..<brain.columns {
                
                let rect = CGRect(origin: CGPoint(x: CGFloat(row) * side, y: CGFloat(col) * side), size: CGSize(width: side - 1, height: side - 1))
                let button = UIButton(frame: rect)
                
                // this flattens the 2d matrix into a sequence of numbers // Wow!
                // our tag is one-based so we add 1
                button.tag = row * brain.columns + col + 1
                
                //UnicodeScalar(65) is A, and a row number added to it will be the next UnicodeScalar.
                let letter = String(Character(UnicodeScalar(65 + row)!))
                
                //Set Button Title
                button.setTitle("\(letter)\(col + 1)", for: UIControlState())
                
                //add function buttonTapped to the corresponding target with action touchUpInside
                switch computerInputing {
                case true:
                    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                    //button.addTarget(self, action: #selector(getButtonTabbed), for: .allEvents)
                default:
                    button.addTarget(self, action: #selector(buttonTappedToSetShip), for: .touchUpInside)
                }
                //add a subview button in UIView
                v.addSubview(button)
            }
        }
        //draw the board
        switch computerInputing {
        case true:
            drawBoard(settingUp: false)
        default:
            drawBoard(settingUp: true)
        }
    }
    
    func setUpGameButtons2(v: UIView, computerInputing: Bool) {
        // remove all views from the container
        // this helps both with resetting and if viewDidLayoutSubviews is called more than once
        for v in v.subviews {
            v.removeFromSuperview()
        }
        
        let side : CGFloat = v.bounds.size.width / CGFloat(brain.rows)
        for row in 0..<brain.rows {
            for col in 0..<brain.columns {
                
                let rect = CGRect(origin: CGPoint(x: CGFloat(row) * side, y: CGFloat(col) * side), size: CGSize(width: side - 1, height: side - 1))
                let button = UIButton(frame: rect)
                
                // this flattens the 2d matrix into a sequence of numbers // Wow!
                // our tag is one-based so we add 1
                button.tag = row * brain.columns + col + 1
                
                //UnicodeScalar(65) is A, and a row number added to it will be the next UnicodeScalar.
                let letter = String(Character(UnicodeScalar(65 + row)!))
                
                //Set Button Title
                button.setTitle("\(letter)\(col + 1)", for: UIControlState())
                
                //add function buttonTapped to the corresponding target with action touchUpInside
                switch computerInputing {
                case true:
                    button.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
                //button.addTarget(self, action: #selector(getButtonTabbed), for: .allEvents)
                default:
                    button.addTarget(self, action: #selector(buttonTappedToSetShip), for: .touchUpInside)
                }
                //add a subview button in UIView
                v.addSubview(button)
            }
        }
        //draw the board
        switch computerInputing {
        case true:
            drawBoard2(settingUp: false)
        default:
            drawBoard2(settingUp: true)
        }
    }

    
    
    func startGame() {
        //Reset the board
        brain.resetBoard()
        //setUpGameButtons to object gridView that was linked to storyboard
        setUpGameButtons(v: gridView, computerInputing: false)
        //Update messageLable
        messageLabel.text = "Select five than press play!"
    }
    func startGame2() {
        //Reset the board
        brain.resetBoard()
        //setUpGameButtons to object gridView2 that was linked to storyboard
        setUpGameButtons2(v: gridView2, computerInputing: false)
        //Update messageLable
        messageLabel.text = "Select five than press play!"
    }
    func startComputerGame() {
        //don't do brain.resetBoard() because we are not resetting
        //drawBoard(settingUp: false)
        setUpGameButtons(v: gridView, computerInputing: true)
        messageLabel.text = "Tap any button!"
    }
    //func for reset game if the button for resetTapped receives a tap
    @IBAction func resetTapped(_ sender: UIButton) {
        startGame()
    }
    @IBAction func readyToPlay(_ sender: UIButton) {
        startComputerGame()
    }
}


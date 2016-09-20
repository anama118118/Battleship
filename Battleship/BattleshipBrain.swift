//
//  BattleshipBrain.swift
//  Battleship
//
//  Created by Jason Gresh on 9/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//


import Foundation

class BattleshipBrain {
    enum Coordinate {
        enum Ship {
            case carrier(Int)
            case battleship(Int)
        }
        enum State {
            case hidden, shown
        }
        case occupied(State, Ship)
        case empty(State, Ship?)
        
        //mutating func when trying to hit
        mutating func tryToHit() -> Bool {
            switch self {
            case .occupied(let state, let ship):
                switch state {
                case .hidden:
                    self = Coordinate.occupied(.shown, ship)
                    return true
                case .shown:
                    return true
                }
            case .empty:
                self = Coordinate.empty(.shown, nil)
                return false
            }
        }
        //mutating func when player 1 hits
        mutating func setUpForHit() -> Bool {
            switch self {
            case .empty(let state, nil):
                switch state{
                case .hidden:
                    self = Coordinate.occupied(.hidden, Ship.battleship(1))
                    return true
                case .shown:
                    self = Coordinate.occupied(.hidden, Ship.battleship(1))
                    return true
                }
            case .occupied(let state, let ship):
                switch state{
                case .hidden:
                    self = Coordinate.occupied(.hidden, ship)
                    return false
                case .shown:
                    self = Coordinate.occupied(.hidden, ship)
                    return false
                }
            default:
                self = Coordinate.occupied(.hidden, Ship.battleship(1))
                return true
            }
        }
    }
    
    let rows: Int
    let columns: Int
    
    //coordinates is arranged by an array
    private var coordinates: [[Coordinate]]
    
    init(rows: Int, columns: Int){
        self.rows = rows
        self.columns = columns
        self.coordinates = [[Coordinate]]()
        setupBoard()
    }
    
    func setupBoard() {
        for _ in 0..<rows {
            self.coordinates.append([Coordinate](repeating:.empty(.hidden, nil), count: columns))
        }
        //print(BattleshipBrain.Coordinate.self)
        //dump(BattleshipBrain.Coordinate.self)
    }
    
    func resetBoard() {
        self.coordinates = [[Coordinate]]()
        setupBoard()
    }
    
    subscript(i: Int, j: Int) -> Coordinate {
        return coordinates[i][j]
    }
    
    func strike(atRow r: Int, andColumn c: Int) -> Bool {
        return coordinates[r][c].tryToHit()
    }
    
    func set(atRow r: Int, andColumn c: Int) -> Bool {
        return coordinates[r][c].setUpForHit()
    }
    
    func gameFinished() -> Bool {
        for r in 0..<rows {
            for c in 0..<columns {
                // if any occupied coordinates are hidden we're not done
                if case .occupied(.hidden, _) = coordinates[r][c] {
                    return false
                }
            }
        }
        return true
    }
    
    func gameSetUpComplete() -> Bool {
        var counter = 0
        for r in 0..<rows {
            for c in 0..<columns {
                // if any occupied coordinates are hidden we're not done
                if case .occupied(.hidden, _) = coordinates[r][c] {
                    counter += 1
                    print(coordinates[r][c])
                    dump(coordinates[r][c])
                    print(r, c)
                    
                }
            }
        }
        if counter < 6 {
            return false
        }
        return true
    }
    
    func computGuessingAtRandomIndex (index: Int) -> [[Coordinate]] {
        var guessArray = [[Coordinate]]()
        for _ in 0...index{
            let a = Int(arc4random_uniform(UInt32(rows)))
            let b = Int(arc4random_uniform(UInt32(columns)))
            guessArray.append([coordinates[a][b]])
        }
        return guessArray
    }
}

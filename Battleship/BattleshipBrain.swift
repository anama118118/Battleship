//
//  BattleshipBrain.swift
//  Battleship
//
//  Created by Ana Ma on 9/16/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class BattleshipBrain {
    let numCards: Int
    
    init(numCards:Int){
        self.numCards = numCards
        setupCards()
    }
    fileprivate enum State{
        case miss
        case hitable
        case beenHit
    }
    private  var cards = [State]()
    func setupCards(){
        cards = Array(repeating: .miss, count: numCards)
        func randomBool() -> Bool {
            return arc4random_uniform(2) == 0
        }
        let randomNum : [Int] = [
            Int(arc4random_uniform(UInt32(numCards))),
            Int(arc4random_uniform(UInt32(numCards))),
            Int(arc4random_uniform(UInt32(numCards))),
            Int(arc4random_uniform(UInt32(numCards))),
            Int(arc4random_uniform(UInt32(numCards)))
        ]
        var arrayOfArrayOfShips: [[Int]] = [[0,0],[0,0,0],[0,0,0],[0,0,0,0],[0,0,0,0,0]]
        var doubleCheckNoDuplicates : [Int] = []
        for m in 0..<randomNum.count { //0...4 in this case
            if randomBool(){ //Randomly call true or false
                if randomNum[m] < (100 - (10 * (arrayOfArrayOfShips[m].count - 1))) {
                    //To make sure the largest element of the corresponding ship array is smaller than or equal to 100 (Vertically)
                    var arrayOfInt1: [Int] = []
                    for i in 0..<arrayOfArrayOfShips[m].count {
                        arrayOfInt1.append(randomNum[m] + 10 * i)
                        doubleCheckNoDuplicates.append(randomNum[m] + 10 * i)
                    }
                    arrayOfArrayOfShips[m] = arrayOfInt1
                    //ship laying in the vertical direction
                }
                else if (randomNum[m] / 10) == ((randomNum[m] + (arrayOfArrayOfShips[m].count - 1)) / 10) {
                    //To make sure the largest element of the corresponding ship array is smaller than or equal to 100 (Horizontally). In case the above previous case fails.
                    var arrayOfInt2: [Int] = []
                    for i in 0..<arrayOfArrayOfShips[m].count {
                        arrayOfInt2.append(randomNum[m] + i)
                        doubleCheckNoDuplicates.append(randomNum[m] + i)
                    }
                    arrayOfArrayOfShips[m] = arrayOfInt2
                }
                else { //If both above cases fail, append something else that works
                    var arrayOfInt3: [Int] = []
                    let t = arrayOfArrayOfShips[m].count - 1
                    for i in 11...(11 + t) {
                        arrayOfInt3.append(i)
                        doubleCheckNoDuplicates.append(i)
                    }
                    arrayOfArrayOfShips[m] = arrayOfInt3
                }
            }
            else {
                if (randomNum[m] / 10) == ((randomNum[m] + (arrayOfArrayOfShips[m].count - 1)) / 10) {
                    //To make sure the largest element of the corresponding ship array is smaller than or equal to 100 (Horizontally)
                    var arrayOfInt4: [Int] = []
                    for i in 0..<arrayOfArrayOfShips[m].count {
                        arrayOfInt4.append(randomNum[m] + i)
                        doubleCheckNoDuplicates.append(randomNum[m] + i)
                    }
                    arrayOfArrayOfShips[m] = arrayOfInt4
                }
                else if randomNum[m] < (100 - 10 * (arrayOfArrayOfShips[m].count - 1)) {
                    //To make sure the largest element of the corresponding ship array is smaller than or equal to 100 (Vertically). In case the above previous case fails.
                    var arrayOfInt5: [Int] = []
                    for i in 0..<arrayOfArrayOfShips[m].count {
                        arrayOfInt5.append(randomNum[m] + 10 * i)
                        doubleCheckNoDuplicates.append(randomNum[m] + 10 * i)
                    }
                    arrayOfArrayOfShips[m] = arrayOfInt5
                }
                else { //If both above cases fail, append something else that works
                    var arrayOfInt6: [Int] = []
                    let t = arrayOfArrayOfShips[m].count - 1
                    for i in 11...(11 + t) {
                        arrayOfInt6.append(i)
                        doubleCheckNoDuplicates.append(i)
                    }
                    arrayOfArrayOfShips[m] = arrayOfInt6
                }
            }
        }
        for j in 0...4 { // change the miss to hitable
            for k in arrayOfArrayOfShips[j] where randomNum[j] < numCards - arrayOfArrayOfShips[j].count{
                cards[k] = .hitable
            }
        }
        print(arrayOfArrayOfShips)
        var doubleCheckDictionary : [Int: Int] = [:]
        //Check the presence of duplication. Resetup cards if present.
        for num in doubleCheckNoDuplicates {
            if doubleCheckDictionary[num] != nil {
                doubleCheckDictionary[num]! += 1
            } else {
                doubleCheckDictionary[num] = 1
            }
        }
        for (_, value) in doubleCheckDictionary {
            if value >= 2 {
                setupCards()
            }
        }
    }
    func hitCards(_ cardIn: Int) -> Bool {
        return cards[cardIn] == .hitable
    }
    func beenHitCards(_ cardIn: Int) -> Bool {
        return cards[cardIn] == .beenHit
    }
    func hitableToBeenHit (_ cardIn: Int) -> () {
        return cards[cardIn] = .beenHit
    }
    func noMoreHitable() -> Bool {
        var count: [State: Int] = [:]
        //var hitableCount = cards
        for i in cards {
            count[i] = (count[i] ?? 0) + 1
        }
        print(count)
        if count[.hitable] == nil {
            return true
        }
        return false
    }
}

//This game supports more than one hit
//It has an Enum for miss, hitable and beenHit
//If all hitable are beenhit, game is over
//Red is a hit, white is a miss, blue is not yet touched
//Make string array of connected box

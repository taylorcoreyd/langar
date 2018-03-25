//
//  Quiz.swift
//  langar
//
//  Created by Francesco Fanizza on 3/25/18.
//  Copyright © 2018 ws. All rights reserved.
//

import Foundation

class Quiz {
    
    var quizCounter = 0
    
    // Solution based on model generated
    var solutions: [String: String] = ["banana": "trái chuối",
                                       "boot": "khởi động",
                                       "bottle": "chai",
                                       "car": "xe hơi",
                                       "flower": "Hoa",
                                       "glasses": "kính",
                                       "money": "tiền bạc",
                                       "orange": "trái cam",
                                       "pen": "bút mực",
                                       "pencil": "bút chì",
                                       "sneaker": "giày",
                                       "spoon": "cái thìa",
                                       "tree": "cây"]
    
    let wrongAnswers = ["máy vi tính", "cá vàng", "con sông", "điện thoại", "bàn", "áo sơ mi", "quân dai"]
    
    let object: String!
    let solution: String!
    
    init(object: String!) {
        self.object = object
        self.solution = solutions[object]
    }
    
    func checkSolution(guess: String) -> Bool {
        // Check the user's guess against the correct response, return a Bool
        return solution == guess
    }
    
    func getOptions() -> [String] {
        // Set UI elements for current identification quiz, based on model (solution)
        // Return values of the buttons
        let choiceOne = Int(arc4random_uniform(UInt32(wrongAnswers.count)))
        var choiceTwo = Int(arc4random_uniform(UInt32(wrongAnswers.count)))
        if choiceTwo == choiceOne {
            choiceTwo = (choiceOne + 1) % wrongAnswers.count
        }
        switch Int(arc4random_uniform(3)) {
        case 1: // buttonOne is correct
            return [self.solution, wrongAnswers[choiceOne], wrongAnswers[choiceTwo]]
        case 2: // buttonThree is correct
            return [wrongAnswers[choiceOne], self.solution, wrongAnswers[choiceTwo]]
        default: // buttonTwo is correct
            return [wrongAnswers[choiceOne], wrongAnswers[choiceOne], self.solution]
        }
    }
    
    
    
}

//
//  QuizGenerator.swift
//  langar
//
//  Created by Francesco Fanizza on 3/24/18.
//  Copyright © 2018 ws. All rights reserved.
//

import Foundation
import UIKit

class QuizGenerator {
    
    func generateQuizOne (questionTextView: UITextView, buttonOne: UIButton, buttonTwo: UIButton, buttonThree: UIButton) {
    
        var wrongAnswers = ["máy vi tính", "cá vàng", "con sông", "chó", "điện thoại", "bàn"]
        var question: String = "Đây là một _________"
        var soln: String = "tờ báo"
        let solnNum = Int(arc4random_uniform(3))
        var i = 0

        questionTextView.text = question
        if solnNum == 1 {
            buttonOne.setTitle(soln, for: [])
        } else {
            buttonOne.setTitle(wrongAnswers[i], for: [])
            i += 1
        }
        if solnNum == 2 {
            buttonTwo.setTitle(soln, for: [])
        } else {
            buttonTwo.setTitle(wrongAnswers[i], for: [])
            i += 1
        }
        if solnNum == 3 {
            buttonThree.setTitle(soln, for: [])
        } else {
            buttonThree.setTitle(wrongAnswers[i], for: [])
            i += 1
        }
        
    }
}

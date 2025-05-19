//
//  Model.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import Foundation
import SwiftData

struct QuizQuestion: Codable, Identifiable {
    let id: Int
    let question: String
    let options: [String: String]
    let correctAnswer: String

    enum CodingKeys: String, CodingKey {
        case id, question, options
        case correctAnswer = "correct_answer"
    }
}

@Model
class AnsweredQuestion {
    var questionID: Int
    var selectedOption: String

    init(questionID: Int, selectedOption: String) {
        self.questionID = questionID
        self.selectedOption = selectedOption
    }
}

@Model
class AppState {
    var lastQuestionID: Int?

    init(lastQuestionID: Int? = nil) {
        self.lastQuestionID = lastQuestionID
    }
}

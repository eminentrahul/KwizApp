//
//  Model.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import Foundation

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

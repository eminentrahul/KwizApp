//
//  QuizViewModel.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import Foundation

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var selectedAnswers: [Int: String] = [:]

    init() {
        loadQuestions()
    }

    func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "IndianHistory", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            questions = try JSONDecoder().decode([QuizQuestion].self, from: data)
        } catch {
            print("Decoding error: \(error)")
        }
    }

    func isCorrect(for question: QuizQuestion, selected: String) -> Bool {
        return question.correctAnswer == selected
    }

    // MARK: - Score Calculations
    var totalQuestions: Int {
        questions.count
    }

    var totalAnswered: Int {
        selectedAnswers.count
    }

    var totalCorrect: Int {
        selectedAnswers.filter { questionID, selected in
            if let question = questions.first(where: { $0.id == questionID }) {
                return question.correctAnswer == selected
            }
            return false
        }.count
    }

    var totalIncorrect: Int {
        totalAnswered - totalCorrect
    }

    var percentageCorrect: Double {
        guard totalAnswered > 0 else { return 0 }
        return (Double(totalCorrect) / Double(totalAnswered)) * 100
    }
}


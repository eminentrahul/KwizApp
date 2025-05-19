//
//  QuizViewModel.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import Foundation

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var selectedAnswers: [Int: String] = [:] // Question ID -> selected option key

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
}

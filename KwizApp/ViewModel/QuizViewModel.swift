//
//  QuizViewModel.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import SwiftUI
import SwiftData

@MainActor
class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []

    @Published var selectedAnswers: [Int: String] = [:]

    private var modelContext: ModelContext

    @Published var lastQuestionID: Int?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadQuestions()
        loadAnswers()
        loadLastScrollPosition()
    }

    func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "IndianHistory", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([QuizQuestion].self, from: data) else {
            print("Failed to load JSON")
            return
        }
        questions = decoded
    }

    func loadAnswers() {
        let answers = try? modelContext.fetch(FetchDescriptor<AnsweredQuestion>())
        for answer in answers ?? [] {
            selectedAnswers[answer.questionID] = answer.selectedOption
        }
    }

    func loadLastScrollPosition() {
        let states = try? modelContext.fetch(FetchDescriptor<AppState>())
        lastQuestionID = states?.first?.lastQuestionID
    }

    func saveAnswer(questionID: Int, selected: String) {
        selectedAnswers[questionID] = selected
        let new = AnsweredQuestion(questionID: questionID, selectedOption: selected)
        modelContext.insert(new)

        try? modelContext.save()
    }

    func saveScrollPosition(id: Int) {
        let state = (try? modelContext.fetch(FetchDescriptor<AppState>()))?.first ?? AppState()
        state.lastQuestionID = id
        modelContext.insert(state)
        try? modelContext.save()
    }

    func reset() {
        let answers = try? modelContext.fetch(FetchDescriptor<AnsweredQuestion>())
        answers?.forEach { modelContext.delete($0) }

        let states = try? modelContext.fetch(FetchDescriptor<AppState>())
        states?.forEach { modelContext.delete($0) }

        try? modelContext.save()

        selectedAnswers = [:]
        lastQuestionID = nil
    }

    var totalQuestions: Int { questions.count }
    var totalAnswered: Int { selectedAnswers.count }
    var totalCorrect: Int {
        selectedAnswers.filter { qid, selected in
            questions.first(where: { $0.id == qid })?.correctAnswer == selected
        }.count
    }
    var totalIncorrect: Int { totalAnswered - totalCorrect }
    var percentageCorrect: Double {
        guard totalAnswered > 0 else { return 0 }
        return (Double(totalCorrect) / Double(totalAnswered)) * 100
    }

    func isCorrect(for question: QuizQuestion, selected: String) -> Bool {
        return question.correctAnswer == selected
    }
}


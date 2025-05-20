//
//  ScoreDetailView.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 20/05/25.
//

import SwiftUI

struct ScoreDetailView: View {
    @ObservedObject var viewModel: QuizViewModel
    @State private var selectedTab: Tab = .correct

    enum Tab: String, CaseIterable {
        case correct = "Correct"
        case incorrect = "Incorrect"
        case skipped = "Skipped"
    }

    var body: some View {
        VStack {
            Picker("Select Tab", selection: $selectedTab) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List(filteredQuestions) { question in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Q\(question.id): \(question.question)")
                        .fontWeight(.semibold)

                    ForEach(question.options.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        HStack {
                            Text("\(key). \(value)")
                            if viewModel.selectedAnswers[question.id] == key {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(viewModel.isCorrect(for: question, selected: key) ? .green : .red)
                            }
                            if question.correctAnswer == key && viewModel.selectedAnswers[question.id] != key {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Score Breakdown")
    }

    private var filteredQuestions: [QuizQuestion] {
        switch selectedTab {
        case .correct:
            return viewModel.questions.filter { q in
                if let selected = viewModel.selectedAnswers[q.id] {
                    return selected == q.correctAnswer
                }
                return false
            }
        case .incorrect:
            return viewModel.questions.filter { q in
                if let selected = viewModel.selectedAnswers[q.id] {
                    return selected != q.correctAnswer
                }
                return false
            }
        case .skipped:
            return viewModel.questions.filter { q in
                viewModel.skippedQuestions.contains(q.id)
            }
        }
    }
}

//
//  ContentView.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = QuizViewModel()

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    Section {
                        ScoreView(
                            totalQuestions: viewModel.totalQuestions,
                            answered: viewModel.totalAnswered,
                            correct: viewModel.totalCorrect,
                            incorrect: viewModel.totalIncorrect,
                            percentage: viewModel.percentageCorrect
                        )
                    }

                    ForEach(viewModel.questions) { question in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(question.question)
                                .font(.headline)

                            ForEach(question.options.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                let selected = viewModel.selectedAnswers[question.id]
                                let isSelected = selected == key
                                let isCorrect = isSelected ? viewModel.isCorrect(for: question, selected: key) : nil

                                OptionView(
                                    key: key,
                                    value: value,
                                    isSelected: isSelected,
                                    isCorrect: isSelected ? isCorrect : nil
                                ) {
                                    if selected == nil {
                                        withAnimation {
                                            viewModel.selectedAnswers[question.id] = key
                                        }

                                        // Scroll to next question (if available)
                                        if let currentIndex = viewModel.questions.firstIndex(where: { $0.id == question.id }),
                                           currentIndex + 1 < viewModel.questions.count {
                                            let nextQuestion = viewModel.questions[currentIndex + 1]
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                withAnimation {
                                                    proxy.scrollTo(nextQuestion.id, anchor: .top)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 6)
                        .id(question.id) // important for ScrollViewReader
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Indian History Quiz")
            }
        }
    }
}



#Preview {
    ContentView()
}

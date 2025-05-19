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
            VStack(spacing: 0) {
                // Sticky Score View
                ScoreView(
                    totalQuestions: viewModel.totalQuestions,
                    answered: viewModel.totalAnswered,
                    correct: viewModel.totalCorrect,
                    incorrect: viewModel.totalIncorrect,
                    percentage: viewModel.percentageCorrect
                )

                // Scrollable Quiz Content
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) {
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

                                                // Scroll to next question
                                                if let index = viewModel.questions.firstIndex(where: { $0.id == question.id }),
                                                   index + 1 < viewModel.questions.count {
                                                    let next = viewModel.questions[index + 1]
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                        withAnimation {
                                                            proxy.scrollTo(next.id, anchor: .top)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 2)
                                .padding(.horizontal)
                                .id(question.id)
                            }

                            Spacer(minLength: 40)
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .navigationTitle("Indian History Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
        }
    }
}



#Preview {
    ContentView()
}

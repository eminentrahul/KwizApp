//
//  ContentView.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: QuizViewModel

    @State private var scrollTarget: Int?

    init() {
        let container = try! ModelContainer(for: AnsweredQuestion.self, AppState.self)
        _viewModel = StateObject(wrappedValue: QuizViewModel(modelContext: container.mainContext))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScoreView(
                    totalQuestions: viewModel.totalQuestions,
                    answered: viewModel.totalAnswered,
                    correct: viewModel.totalCorrect,
                    incorrect: viewModel.totalIncorrect,
                    percentage: viewModel.percentageCorrect
                )

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
                                            guard selected == nil else { return }

                                            withAnimation {
                                                viewModel.saveAnswer(questionID: question.id, selected: key)
                                            }

                                            if let index = viewModel.questions.firstIndex(where: { $0.id == question.id }),
                                               index + 1 < viewModel.questions.count {
                                                let nextID = viewModel.questions[index + 1].id
                                                viewModel.saveScrollPosition(id: nextID)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    withAnimation {
                                                        proxy.scrollTo(nextID, anchor: .top)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .gray.opacity(0.1), radius: 2)
                                .id(question.id)
                            }

                            Spacer(minLength: 40)
                        }
                        .padding(.top)
                    }
                    .onAppear {
                        if let id = viewModel.lastQuestionID {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation {
                                    proxy.scrollTo(id, anchor: .top)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Indian History Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        withAnimation {
                            viewModel.reset()
                        }
                    }
                }
            }
        }
    }
}



#Preview {
    ContentView()
}

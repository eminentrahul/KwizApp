//
//  ContentView.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var currentIndex = 0
    @State private var previousIndex = 0
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: QuizViewModel

    init() {
        let container = try! ModelContainer(for: AnsweredQuestion.self, AppState.self)
        _viewModel = StateObject(wrappedValue: QuizViewModel(modelContext: container.mainContext))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Score always on top
            ScoreView(
                totalQuestions: viewModel.totalQuestions,
                answered: viewModel.totalAnswered,
                correct: viewModel.totalCorrect,
                incorrect: viewModel.totalIncorrect,
                skipped: viewModel.totalSkipped,
                percentage: viewModel.percentageCorrect
            )

            TabView(selection: $currentIndex) {
                ForEach(viewModel.questions.indices, id: \.self) { index in
                    let question = viewModel.questions[index]

                    VStack(alignment: .leading, spacing: 16) {
                        Text(question.question)
                            .font(.title2.bold())

                        ForEach(question.options.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            let isSelected = viewModel.selectedAnswers[question.id] == key
                            let isCorrect = question.correctAnswer == key

                            OptionView(
                                key: key,
                                value: value,
                                isSelected: isSelected,
                                isCorrect: isSelected ? isCorrect : nil
                            ) {
//                                guard !viewModel.isQuestionAnsweredOrSkipped(question.id) else { return }
                                guard !viewModel.selectedAnswers.keys.contains(question.id) else { return }

                                withAnimation {
                                    viewModel.saveAnswer(questionID: question.id, selected: key)
//                                    nextQuestion()
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    withAnimation {
                                        nextQuestion()
                                    }

                                }
                            }
                        }

                        Spacer()

                        Button("Skip Question") {
                            guard !viewModel.isQuestionAnsweredOrSkipped(question.id) else { return }
                            withAnimation {
                                viewModel.skipQuestion(questionID: question.id)
                                nextQuestion()
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentIndex)
            .onChange(of: currentIndex) { _, newIndex in
                let prevQuestion = viewModel.questions[previousIndex]
                if !viewModel.isQuestionAnsweredOrSkipped(prevQuestion.id) {
                    viewModel.skipQuestion(questionID: prevQuestion.id)
                }
                previousIndex = newIndex
            }
        }
        .onAppear {
            let firstIndex = viewModel.firstUnansweredQuestionIndex()
            currentIndex = firstIndex
            previousIndex = firstIndex
        }
        .navigationBarTitle("Indian History Quiz", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Reset") {
                    withAnimation {
                        viewModel.reset()
                        currentIndex = 0
                        previousIndex = 0
                    }
                }
            }
        }
    }

    func nextQuestion() {
        if currentIndex + 1 < viewModel.questions.count {
            currentIndex += 1
        }
    }
}



#Preview {
    ContentView()
}

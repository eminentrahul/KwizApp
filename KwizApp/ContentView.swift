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
            List {
                ForEach(viewModel.questions) { question in
                    VStack(alignment: .leading, spacing: 12) {
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
                                if selected == nil { // allow only first selection
                                    viewModel.selectedAnswers[question.id] = key
                                }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("Indian History Quiz")
        }
    }
}


#Preview {
    ContentView()
}

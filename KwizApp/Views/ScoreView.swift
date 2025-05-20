//
//  ScoreView.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import SwiftUI

struct ScoreView: View {
    let totalQuestions: Int
    let answered: Int
    let correct: Int
    let incorrect: Int
    var skipped: Int
    let percentage: Double
    @ObservedObject var viewModel: QuizViewModel

    var body: some View {
        NavigationLink(destination: ScoreDetailView(viewModel: viewModel)) {
            HStack(spacing: 20) {
                AnimatedCounter(value: totalQuestions, label: "Total")
                AnimatedCounter(value: answered, label: "Answered")
                AnimatedCounter(value: correct, label: "Correct")
                AnimatedCounter(value: incorrect, label: "Incorrect")
                AnimatedCounter(value: skipped, label: "Skipped")
                
                VStack(spacing: 4) {
                    Text(String(format: "%.0f%%", percentage))
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Accuracy")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding([.horizontal, .top])
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

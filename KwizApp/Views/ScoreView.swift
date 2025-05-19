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
    let percentage: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("📊 Quiz Progress")
                .font(.headline)

            HStack {
                Text("Total Questions: \(totalQuestions)")
                Spacer()
                Text("Answered: \(answered)")
            }

            HStack {
                Text("✔️ Correct: \(correct)")
                Spacer()
                Text("❌ Incorrect: \(incorrect)")
            }

            ProgressView(value: percentage, total: 100)
                .accentColor(.green)

            Text(String(format: "Accuracy: %.1f%%", percentage))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

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
                
                VStack(alignment: .leading, spacing: 20) {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                        .clipShape(.buttonBorder)
                        .overlay {
                            Text("Total - \(totalQuestions)")
                                .foregroundStyle(.white)
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                    
                    VStack {
                        HStack (spacing: 10){
                            AnimatedCounter(value: answered, color: .blue)
                            AnimatedCounter(value: correct, color: .green)
                        }
                        
                        HStack(spacing: 10) {
                            AnimatedCounter(value: incorrect, color: .red)
                            AnimatedCounter(value: skipped, color: .orange)
                        }
                    }
                   
                }.padding()
                
                VStack {
                    HStack(spacing: 20) {
                        CircularStatView(value: correct, total: answered, label: "Correct", color: .green, ringSize: 80, fontSize: 16)
                        CircularStatView(value: incorrect, total: answered, label: "Incorrect", color: .red, ringSize: 80, fontSize: 16)
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        CircularStatView(value: skipped, total: totalQuestions, label: "Skipped", color: .orange, ringSize: 80, fontSize: 16)
                        CircularStatView(value: answered, total: totalQuestions, label: "Answered", color: .blue, ringSize: 80, fontSize: 16)
                    }
                    
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

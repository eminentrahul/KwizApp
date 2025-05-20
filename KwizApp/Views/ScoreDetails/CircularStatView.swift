//
//  CircularStatView.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 20/05/25.
//

import SwiftUI

struct CircularStatView: View {
    let value: Int
    let total: Int
    let label: String
    let color: Color
    let ringSize: CGFloat
    let fontSize: CGFloat

    private var percentage: Double {
        guard total > 0 else { return 0 }
        return (Double(value) / Double(total)) * 100
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: 10)

            Circle()
                .trim(from: 0, to: CGFloat(percentage / 100))
                .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: value)

            VStack {
                Text("\(Int(percentage))%")
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(color)
                Text(label)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: ringSize, height: ringSize)
    }
}

#Preview {
    CircularStatView(value: 38, total: 100, label: "Correct", color: .green, ringSize: 100, fontSize: 20)
}

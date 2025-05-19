//
//  OptionView.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import Foundation
import SwiftUI

struct OptionView: View {
    let key: String
    let value: String
    let isSelected: Bool
    let isCorrect: Bool?
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(key)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(circleColor)
                .clipShape(Circle())

            Text(value)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
            onTap()
        }
    }

    private var circleColor: Color {
        if let correct = isCorrect {
            return correct ? .green : .red
        }
        return .blue
    }
}

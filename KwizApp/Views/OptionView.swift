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
                .animation(.easeInOut(duration: 0.3), value: circleColor)
            
            Text(value)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .animation(.easeInOut(duration: 0.3), value: backgroundColor)
        .onTapGesture {
            onTap()
        }
        .scaleEffect(isSelected ? 1.05 : 1)
        .animation(.spring(), value: isSelected)
    }
    
    private var circleColor: Color {
        if isSelected {
            if isCorrect == true {
                return .green
            } else if isCorrect == false {
                return .red
            }
        } else if isCorrect == true {
            return .green
        }
        return .blue
    }
    
    private var backgroundColor: Color {
        // Selected & Correct
        if isSelected, isCorrect == true {
            return Color.green.opacity(0.3)
        }
        // Selected & Incorrect
        else if isSelected, isCorrect == false {
            return Color.red.opacity(0.3)
        }
        // Not selected, but this is the correct option (i.e., user chose wrong one)
        else if !isSelected, isCorrect == true {
            return Color.green.opacity(0.2)
        }
        // Default background
        else {
            return Color.gray.opacity(0.1)
        }
    }
}

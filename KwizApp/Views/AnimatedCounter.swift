//
//  AnimatedCounter.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 19/05/25.
//

import Foundation
import SwiftUI

struct AnimatedCounter: View {
    var value: Int
    var label: String

    @State private var animatedValue: Int = 0

    var body: some View {
        VStack(spacing: 4) {
            // Animating value with upward transition
            Text("\(animatedValue)")
                .font(.title2)
                .fontWeight(.bold)
                .transition(.move(edge: .top).combined(with: .opacity))
                .id(animatedValue) // required for animation

            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .onChange(of: value) { _, newValue in
            withAnimation(.easeInOut(duration: 0.4)) {
                animatedValue = newValue
            }
        }
        .onAppear {
            animatedValue = value
        }
    }
}

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
    let color: Color

    @State private var animatedValue: Int = 0

    var body: some View {
        VStack(spacing: 4) {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .clipShape(.buttonBorder)
                .foregroundStyle(color)
                .overlay {
                    Text("\(animatedValue)")
                        .foregroundStyle(.white)
                        .font(.callout)
                        .fontWeight(.bold)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .id(animatedValue)
                }
            
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

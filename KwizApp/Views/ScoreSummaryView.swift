//
//  ScoreSummaryView.swift
//  KwizApp
//
//  Created by Rahul Ravi Prakash on 20/05/25.
//

import SwiftUI

struct ScoreSummaryView: View {
    let total = 1000
    let answered = 69
    let correct = 24
    let incorrect = 45
    let skipped = 12

    private var accuracy: Double {
        guard answered > 0 else { return 0 }
        return (Double(correct) / Double(answered)) * 100
    }

    var body: some View {
        VStack(spacing: 40) {
            // Large Answered + Accuracy Ring
            CircularStatView(
                value: answered,
                total: total,
                label: "Accuracy",
                color: .blue,
                ringSize: 180,
                fontSize: 30
            )

            // Small Stats Ring
            HStack(spacing: 30) {
                CircularStatView(value: correct, total: answered, label: "Correct", color: .green, ringSize: 80, fontSize: 16)
                CircularStatView(value: incorrect, total: answered, label: "Incorrect", color: .red, ringSize: 80, fontSize: 16)
                CircularStatView(value: skipped, total: total, label: "Skipped", color: .orange, ringSize: 80, fontSize: 16)
            }
            let segments = [
                DonutSegment(color: .green, value: Double(correct), label: "Correct"),
                DonutSegment(color: .red, value: Double(incorrect), label: "Incorrect"),
                DonutSegment(color: .yellow, value: Double(skipped), label: "Skipped")
                    ]
            
            DonutChartView(segments: segments, total: Double(answered), accuracy: accuracy)
        }
        .padding()
    }
}

#Preview {
    ScoreSummaryView()
}

struct DonutSegment {
    let color: Color
    let value: Double
    let label: String
}

struct DonutChartView: View {
  let segments: [DonutSegment]
  let total: Double
  let accuracy: Double

  // 1. Precompute the start/end angles for each slice
  private var slices: [(start: Double, end: Double, color: Color)] {
    var angleAccumulator = -90.0
    return segments.map { segment in
      let sweep = segment.value / total * 360
      let slice = (start: angleAccumulator,
                   end:   angleAccumulator + sweep,
                   color: segment.color)
      angleAccumulator += sweep
      return slice
    }
  }

  var body: some View {
    GeometryReader { geo in
      ZStack {
        // background track
        Circle()
          .trim(from: 0, to: 1)
          .stroke(Color.gray.opacity(0.2), lineWidth: 40)
        
        // 2. Emit each slice using precomputed angles
        ForEach(Array(slices.enumerated()), id: \.offset) { _, slice in
          Circle()
            .trim(from: CGFloat(slice.start / 360),
                  to:   CGFloat(slice.end / 360))
            .stroke(slice.color, lineWidth: 40)
            .rotationEffect(.degrees(-90))
        }
        
        // center label...
        VStack {
          Text(String(format: "%.0f%%", accuracy))
            .font(.title)
            .fontWeight(.bold)
          Text("Accuracy")
            .font(.caption)
            .foregroundColor(.gray)
        }
      }
      .frame(width: geo.size.width * 0.5, height: geo.size.width * 0.5)
    }
    .aspectRatio(1, contentMode: .fit)
    .padding()
  }
}


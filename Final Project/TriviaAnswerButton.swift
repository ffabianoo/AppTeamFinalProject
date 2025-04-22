//
//  TriviaAnswerButton.swift
//  Final Project
//
//  Created by Francesca Fabiano-Grossi on 4/22/25.
//

import SwiftUI

struct TriviaAnswerButton: View {
    let answer: String
    let isCorrect: Bool
    @Binding var selectedAnswer: String?
    @Binding var showAnswer: Bool
    @Binding var score: Int

    var body: some View {
        Button(action: {
            selectedAnswer = answer
            showAnswer = true
            if isCorrect {
                score += 1
            }
        }) {
            Text(answer)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    showAnswer && answer == selectedAnswer
                        ? (isCorrect ? Color.green.opacity(0.4) : Color.red.opacity(0.3))
                        : Color.blue.opacity(0.2)
                )
                .cornerRadius(10)
        }
        .disabled(showAnswer)
    }
}

//
//  ContentView.swift
//  Final Project
//
//  Created by Francesca Fabiano-Grossi on 4/8/25.
//

import SwiftUI

struct ContentView: View {
    @State private var triviaQuestions: [TriviaQuestion] = []
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var showAnswer = false
    @State private var selectedAnswer: String? = nil
    @State private var quizStarted = false
    @State private var quizComplete = false
    @State private var selectedDifficulty = "medium"
    let difficulties = ["easy", "medium", "hard"]
    
    
    var body: some View {
        ZStack {
            Color(red: 0.0, green: 0.0, blue: 0.3) // Navy blue
                .ignoresSafeArea()
            
            
            VStack(spacing: 20) {
                if !quizStarted {
                    Text("🧠 Trivia Time")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Test your knowledge with 10 random trivia questions.")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.white)
                    
                    Button("Start Quiz") {
                        score = 0
                        quizStarted = true
                        loadTrivia()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.3, green: 0.6, blue: 1.0))
                    .cornerRadius(10)
                } else if triviaQuestions.isEmpty {
                    VStack {
                    ProgressView()
                    Text("Loading trivia...")
                        .foregroundColor(.white)
                }
                    
                } else if quizComplete {
                    VStack(spacing: 20) {
                        Text("Quiz Complete!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("You scored \(score) out of \(triviaQuestions.count)!")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Button("Play Again") {
                            quizComplete = false
                            quizStarted = false
                            triviaQuestions = []
                            currentIndex = 0
                            score = 0
                            showAnswer = false
                            selectedAnswer = nil
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                } else {
                    let question = triviaQuestions[currentIndex]
                    Text("Score: \(score)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(decodeHTML(question.question))
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.white)
                    
                    ForEach(question.allAnswersShuffled, id: \.self) { answer in
                        TriviaAnswerButton(
                            answer: decodeHTML(answer),
                            isCorrect: answer == question.correct_answer,
                            selectedAnswer: $selectedAnswer,
                            showAnswer: $showAnswer,
                            score: $score
                        )
                    }
                    
                    
                    if showAnswer {
                        Text("Correct answer: \(decodeHTML(question.correct_answer))")
                            .foregroundColor(.green)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    Button("Next") {
                        if currentIndex < triviaQuestions.count - 1 {
                            currentIndex += 1
                            showAnswer = false
                            selectedAnswer = nil
                        } else {
                            quizComplete = true
                        }
                    }
                    .padding(.top)
                }
            }
            .padding()
        }}
        
        func loadTrivia() {
            Task {
                do {
                    triviaQuestions = try await TriviaManager.getTrivia(difficulty: selectedDifficulty)
                } catch {
                    print("❌ Error loading trivia: \(error)")
                }
            }
        }
        
        
        
        func decodeHTML(_ string: String) -> String {
            guard let data = string.data(using: .utf8) else { return string }
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html
            ]
            let decoded = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
            return decoded?.string ?? string
        }
    }


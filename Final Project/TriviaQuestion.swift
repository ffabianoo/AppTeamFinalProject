//
//  TriviaQuestion.swift
//  Final Project
//
//  Created by Francesca Fabiano-Grossi on 4/22/25.
//
import Foundation

struct TriviaResponse: Codable {
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()  // this is generated locally, not from the API
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]

  
    private enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question, correct_answer, incorrect_answers
    }
}

extension TriviaQuestion {
    var allAnswersShuffled: [String] {
        (incorrect_answers + [correct_answer]).shuffled()
    }
}

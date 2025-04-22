//
//  TriviaManager.swift
//  Final Project
//
//  Created by Francesca Fabiano-Grossi on 4/8/25.
//
import Foundation


// The manager that fetches the data
import Foundation

class TriviaManager {
    static func getTrivia(difficulty: String) async throws -> [TriviaQuestion] {
        let urlString = "https://opentdb.com/api.php?amount=10&category=24&difficulty=\(difficulty)&type=multiple"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TriviaResponse.self, from: data)
        return response.results
    }
}


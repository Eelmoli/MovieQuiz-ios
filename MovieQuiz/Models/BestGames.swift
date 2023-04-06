//
//  BestGames.swift
//  MovieQuiz
//
//  Created by Сергей Кобылянский on 05.04.2023.
//

import Foundation

struct BestGame: Codable { // Decodable + Encodable
    let correct: Int
    let total: Int
    let date: Date
}

extension BestGame: Comparable {
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
    }
    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
    
    
}

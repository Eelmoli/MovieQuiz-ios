//
//  BestGames.swift
//  MovieQuiz
//
//  Created by Сергей Кобылянский on 05.04.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
        }
    }

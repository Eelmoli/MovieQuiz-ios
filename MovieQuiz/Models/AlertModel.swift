//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Сергей Кобылянский on 06.04.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}

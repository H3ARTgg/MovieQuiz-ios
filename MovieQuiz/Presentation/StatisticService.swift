//
//  StatiscticService.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 15.11.2022.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}


//
//  MovieQuizViewControlletProtocol.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 06.12.2022.
//

import Foundation

protocol MovieQuizViewControllerProtocol {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrect: Bool)
}

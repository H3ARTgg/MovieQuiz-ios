//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 10.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func didFailToLoad(message: String)
    func resizedImageLoading()
}

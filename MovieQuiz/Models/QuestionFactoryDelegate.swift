//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 10.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}

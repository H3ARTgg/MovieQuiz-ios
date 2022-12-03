//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 03.12.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var questionFactory: QuestionFactoryProtocol?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
      }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let answer = isYes
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.show(quiz: viewModel)

        }
        viewController?.hideLoadingIndicator()
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
          let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: "",
            buttonText: "Сыграть ещё раз")
          
            viewController?.show(quiz: viewModel)
          
      } else {
          self.switchToNextQuestion()
          questionFactory?.requestNextQuestion()
      }
    }
}

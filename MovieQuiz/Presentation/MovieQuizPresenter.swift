//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 03.12.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func restartGame() {
        correctAnswers = 0
        resetQuestionIndex()
        questionFactory?.requestNextQuestion()
    }
    
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
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
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
    
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    // Для ошибок: при неуспешной загрузке измененного изображения по ссылке и при наличии errorMessage у MostPopularMovies
    func didFailToLoad(message: String) {
        viewController?.showNetworkError(message: message)
    }
    
    // Для отображения индикатора, пока загружается измененное изображение по ссылке
    func resizedImageLoading() {
        viewController?.showLoadingIndicator()
    }
}

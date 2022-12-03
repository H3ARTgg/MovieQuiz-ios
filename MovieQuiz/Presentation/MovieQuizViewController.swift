import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    // MARK: - Lifecycle
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Functions for network
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
            
        }
        
        alertPresenter?.showAlert(alertModel: alert)
    }
    
    // MARK: - AlertPresenterDelegate
    func didRecieveAlertController(alertController: UIAlertController?) {
        guard let alertController = alertController else { return }
        
        present(alertController, animated: true)
        
        
    }
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Private functions
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    func show(quiz result: QuizResultsViewModel) {
        guard let statisticService = statisticService else {
            return
        }
        
        statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        let text = """
  Ваш результат: \(presenter.correctAnswers) из \(presenter.questionsAmount)
  Количество сыгранных квизов: \(statisticService.gamesCount)
  Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
  Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
  """
        let alert = AlertModel(
            title: result.title,
            message: text,
            buttonText: result.buttonText) {
                [weak self] _ in
                guard let self = self else { return }
                self.presenter.restartGame()
            }
        
        alertPresenter?.showAlert(alertModel: alert)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
        
    }
    
//    private func showNextQuestionOrResults() {
//        if presenter.isLastQuestion() {
//          let viewModel = QuizResultsViewModel(
//            title: "Этот раунд окончен!",
//            text: "",
//            buttonText: "Сыграть ещё раз")
//
//          show(quiz: viewModel)
//
//      } else {
//          presenter.switchToNextQuestion()
//          questionFactory?.requestNextQuestion()
//      }
//    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */

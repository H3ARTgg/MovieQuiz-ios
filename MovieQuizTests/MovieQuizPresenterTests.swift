import Foundation
import XCTest

@testable import MovieQuiz

final class MovieQuizControllerProtocolMock: MovieQuizViewControllerProtocol {
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        
    }
}

class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControlletMock = MovieQuizControllerProtocolMock()
        let presenter = MovieQuizPresenter(viewController: viewControlletMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Some Text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Some Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

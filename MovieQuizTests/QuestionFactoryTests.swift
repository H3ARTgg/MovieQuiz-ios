import Foundation
import XCTest

@testable import MovieQuiz

final class moviesLoaderMock: MoviesLoading {
    private enum TestError: Error {
        case Error
    }
    
    let emulateError: Bool
    let fakeURL: Bool
    let moviesWithFakeURL = [
        MostPopularMovie(
            title: "Hello",
            rating: "10",
            imageURL: URL(string: "https")!),
        MostPopularMovie(
            title: "Hi",
            rating: "8",
            imageURL: URL(string: "https")!)]
    let movies = [
        MostPopularMovie(
            title: "Hello",
            rating: "10",
            imageURL: URL(string: "https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZmNhMC00ZDIzLWFmNTEtODM1ZmRlYWMwMWFmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_UX128_CR0,3,128,176_AL_.jpg")!),
        MostPopularMovie(
            title: "Hi",
            rating: "8",
            imageURL: URL(string: "https://m.media-amazon.com/images/M/MV5BMDFkYTc0MGEtZmNhMC00ZDIzLWFmNTEtODM1ZmRlYWMwMWFmXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_UX128_CR0,3,128,176_AL_.jpg")!)
    ]
    var mostPopularMovies: MostPopularMovies
    
    init(emulateError: Bool, errorMessage: String, fakeURL: Bool) {
        self.emulateError = emulateError
        self.fakeURL = fakeURL
        
        if self.fakeURL {
            self.mostPopularMovies = MostPopularMovies(errorMessage: errorMessage, items: moviesWithFakeURL)
        } else {
            self.mostPopularMovies = MostPopularMovies(errorMessage: errorMessage, items: movies)
        }
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.Error))
        } else {
            handler(.success(mostPopularMovies))
        }
    }
    
    
}

class QuestionFactoryTests: XCTestCase, QuestionFactoryDelegate {
    var check = ""
    var imageCheck = ""
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        check = "Question"
    }
    
    func didLoadDataFromServer() {
        check = "Data"
    }
    
    func didFailToLoadData(with error: Error) {
        check = "Error"
    }
    
    func didFailToLoad(message: String) {
        check = "ErrorFromServer"
    }
    
    func resizedImageLoading() {
        imageCheck = "ImageLoading"
    }
    
    func testLoadDataFailure() throws {
        
        let movieLoader = moviesLoaderMock(emulateError: true, errorMessage: "", fakeURL: false)
        let questionFactory = QuestionFactory(delegate: self, moviesLoader: movieLoader)
        
        let expectation = expectation(description: "Load data failure expectation")
        
        questionFactory.loadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            XCTAssertTrue(self.check == "Error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testLoadDataWithError() throws {
        
        let movieLoader = moviesLoaderMock(emulateError: false, errorMessage: "Error", fakeURL: false)
        let questionFactory = QuestionFactory(delegate: self, moviesLoader: movieLoader)
        
        let expectation = expectation(description: "Load data with error expectation")
        
        questionFactory.loadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            XCTAssertTrue(self.check == "ErrorFromServer")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testLoadDataSuccess() throws {
        let movieLoader = moviesLoaderMock(emulateError: false, errorMessage: "", fakeURL: false)
        let questionFactory = QuestionFactory(delegate: self, moviesLoader: movieLoader)
        
        let expectation = expectation(description: "Load data expectation")
        
        questionFactory.loadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            XCTAssertTrue(self.check == "Data")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testRequestQuestionSuccess() throws {
        let movieLoader = moviesLoaderMock(emulateError: false, errorMessage: "", fakeURL: false)
        let questionFactory = QuestionFactory(delegate: self, moviesLoader: movieLoader)
        
        let expectation = expectation(description: "Question requestion success and image loading expectation")
        
        questionFactory.loadData()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) { [weak self] in
            
            questionFactory.requestNextQuestion()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                
                XCTAssertTrue(self.check == "Question")
                XCTAssertTrue(self.imageCheck == "ImageLoading")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4)
    }
    
    func testRequestQuestionImageFail() throws {
        let movieLoader = moviesLoaderMock(emulateError: false, errorMessage: "", fakeURL: true)
        let questionFactory = QuestionFactory(delegate: self, moviesLoader: movieLoader)
        
        let expectation = expectation(description: "Load image with error expectation")
        questionFactory.loadData()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) { [weak self] in
            
            questionFactory.requestNextQuestion()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                
                XCTAssertTrue(self.check == "ErrorFromServer")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 4)
    }
    
}

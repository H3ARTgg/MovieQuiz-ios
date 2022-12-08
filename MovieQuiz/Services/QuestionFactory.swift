import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private enum SomeFails: String, Error {
        case FailToLoadImage = "Ошибка загрузки картинки"
    }
    
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    private weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    if !mostPopularMovies.errorMessage.isEmpty {
                        self.delegate?.didFailToLoad(message: mostPopularMovies.errorMessage)
                    } else {
                        self.delegate?.didLoadDataFromServer()
                    }
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                    
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            let randomRating = (7...9).randomElement() ?? 7
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                DispatchQueue.main.async {
                    self.delegate?.resizedImageLoading()
                }
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoad(message: SomeFails.FailToLoadImage.rawValue)
                }
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем \(randomRating)?"
            let correctAnswer = rating > Float(randomRating)
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
            
        }
    }
}

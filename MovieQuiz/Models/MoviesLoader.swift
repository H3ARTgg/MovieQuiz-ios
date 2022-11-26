//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 25.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_4dl9s1wn") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let newData = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(newData))
                } catch {
                    print("Unable to decode newData")
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

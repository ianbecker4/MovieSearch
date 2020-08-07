//
//  MovieController.swift
//  MovieSearch
//
//  Created by Ian Becker on 8/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import UIKit

class MovieController {
    
    // MARK: - Properties
    static private let baseURL = URL(string: "https://api.themoviedb.org/3")
    static private let searchEndpoint = "search"
    static private let movieEndpoint = "movie"
    static private let apiKeyKey = "api_key"
    static private let apiKey = "c78f1ff73420ad8c387f62d8fa9d553d"
    static private let searchKey = "query"
    static private let imageURL = URL(string: "http://image.tmdb.org/t/p/w500")
    
    
    // MARK: - Fetch Methods
    static func fetchMovie(searchTerm: String, completion: @escaping (Result<[Movie], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let searchURL = baseURL.appendingPathComponent(searchEndpoint)
        let movieURL = searchURL.appendingPathComponent(movieEndpoint)
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        
        components?.queryItems = [ URLQueryItem(name: apiKeyKey, value: apiKey),
                                   URLQueryItem(name: searchKey, value: searchTerm.lowercased())]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(MovieTopLevelObject.self, from: data)
                let movies = topLevelObject.results
                return completion(.success(movies))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchImage(for movie: Movie, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let baseURL = imageURL else {return completion(.failure(.invalidURL))}
        let finalURL = baseURL.appendingPathComponent(movie.image)
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            
            completion(.success(image))
        }.resume()
    }
} // End of class

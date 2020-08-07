import UIKit

// API Key
// https://api.themoviedb.org/3/search/movie?api_key={api_key}&query={searchTerm}
// My key : c78f1ff73420ad8c387f62d8fa9d553d

// Example image URL
// https://image.tmdb.org/t/p/w500/kqjL17yufvn9OVLyXYpvtyrFfak.jpg
// http://image.tmdb.org/t/p/w500/(imageEndpoint)

// MARK: - Model

struct MovieTopLevelObject: Codable {
    
    let results: [Movie]
    
}

struct Movie: Codable {
    
    let title: String
    let rating: Double
    let description: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case rating = "vote_average"
        case description = "overview"
        case image = "poster_path"
    }
}

// MARK: - Model Controller

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
}





// MARK: - Helpers
enum NetworkError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .invalidURL:
            return "Unable to reach the server."
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "The server responded with bad data."
        }
    }
}

// MARK: - "View Controller"

MovieController.fetchMovie(searchTerm: "Ace Ventura") { (movie) in
    print(movie)
}


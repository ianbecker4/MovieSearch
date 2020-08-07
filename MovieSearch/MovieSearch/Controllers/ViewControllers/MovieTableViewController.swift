//
//  MovieTableViewController.swift
//  MovieSearch
//
//  Created by Ian Becker on 8/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    
    // MARK: - Properties
    var movies: [Movie] = []

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieSearchBar.delegate = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else {return UITableViewCell()}
        
        let movie = self.movies[indexPath.row]
    
        MovieController.fetchImage(for: movie) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    cell.movieTitleLabel.text = movie.title
                    cell.movieRatingLable.text = "Rating: \(movie.rating)"
                    cell.movieDescriptionLabel.text = movie.description
                    cell.movieImageView.image = image
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        return cell
    }
} // End of class

    // MARK: - Extensions
extension MovieTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = movieSearchBar.text, !searchTerm.isEmpty else {return}
        
        MovieController.fetchMovie(searchTerm: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    self.movies = movie
                    self.tableView.reloadData()
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
} // End of extension

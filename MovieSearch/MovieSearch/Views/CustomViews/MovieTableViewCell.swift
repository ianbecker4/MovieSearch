//
//  MovieTableViewCell.swift
//  MovieSearch
//
//  Created by Ian Becker on 8/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLable: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UITextView!
    
    // MARK: - Properties
    var movie: Movie? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let movie = movie else {return}
        MovieController.fetchImage(for: movie) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.movieTitleLabel.text = movie.title
                    self.movieRatingLable.text = "Rating: \(movie.rating)"
                    self.movieDescriptionLabel.text = movie.description
                    self.movieImageView.image = image
                case .failure(let error):
                    self.movieImageView.image = UIImage(named: "defaultPoster")
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
} // End of class



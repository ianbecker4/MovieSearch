//
//  Movie.swift
//  MovieSearch
//
//  Created by Ian Becker on 8/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation

struct MovieTopLevelObject: Codable {
    
    let results: [Movie]
    
} // End of struct

struct Movie: Codable {
    
    let title: String
    let rating: Double
    let description: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case rating = "vote_average"
        case description = "overview"
        case image = "poster_path"
    }
} // End of struct

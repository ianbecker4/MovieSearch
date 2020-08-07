//
//  MovieTableViewController.swift
//  MovieSearch
//
//  Created by Ian Becker on 8/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    
    // MARK: - Properties
    var movies: [Movie] = []

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }
} // End of class

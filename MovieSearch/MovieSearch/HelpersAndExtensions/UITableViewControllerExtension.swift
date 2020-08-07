//
//  UITableViewControllerExtension.swift
//  MovieSearch
//
//  Created by Ian Becker on 8/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit

extension MovieTableViewController {
    func presentErrorToUser(localizedError: LocalizedError) {
        let alertController = UIAlertController(title: "ERROR", message: localizedError.errorDescription, preferredStyle: .actionSheet)
        
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true)
    }
}

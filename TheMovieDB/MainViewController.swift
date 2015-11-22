//
//  MainViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/22/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    
    private static let GENRES_ORDER = [MovieGenre.SciFi, MovieGenre.Comedy, MovieGenre.Action]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewControllers = viewControllers {
            for index in viewControllers.indices {
                if viewControllers[index] is GenresViewController {
                    (viewControllers[index] as! GenresViewController).fetchMovies(MainViewController.GENRES_ORDER[index])
                }
            }
        }
    }
    
}
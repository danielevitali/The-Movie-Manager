//
//  MainViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/22/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    private static let GENRES_ORDER = [MovieGenre.SciFi, MovieGenre.Comedy, MovieGenre.Action]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        (viewControllers![0] as! GenresViewController).fetchMovies(MainViewController.GENRES_ORDER[0])
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if viewController is GenresViewController {
            let index = viewControllers!.indexOf(viewController)!
            (viewController as! GenresViewController).fetchMovies(MainViewController.GENRES_ORDER[index])
        }
    }
    
}
//
//  MovieDetailsViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/22/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    @IBOutlet weak var topBar: UINavigationItem!
    
    var movie: Movie!
    var isFavorite: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let favoriteMovies = User.getInstance().favoriteMovies
        if favoriteMovies == nil {
            topBar.rightBarButtonItems?.removeAll()
        } else if favoriteMovies!.contains(movie) {
            btnFavorite.image = UIImage(named: "ic_favorite")
            isFavorite = true
        } else {
            btnFavorite.image = UIImage(named: "ic_favorite_border")
            isFavorite = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imgPoster.image = UIImage(data: NSData(contentsOfURL: Network.getUrlForImage(movie.imageName, size: "original"))!)
        navigationItem.title = movie.title
    }
    
    @IBAction func favoriteClick(sender: AnyObject) {
        var favoriteMovies = User.getInstance().favoriteMovies!
        if isFavorite == true {
            favoriteMovies.removeAtIndex(favoriteMovies.indexOf(movie))
        } else {
            favoriteMovies.insert(movie, atIndex: 0)
        }
    }
}
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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
        addRemoveFavorite(!isFavorite)
    }
    
    private func addRemoveFavorite(favorite: Bool) {
        activityIndicator.startAnimating()
        self.topBar.leftBarButtonItem?.enabled = false
        self.btnFavorite.enabled = false
        
        let request = Network.getRequestForAddRemoveFavoriteMovie(User.getInstance().accountId!, movieId: movie.id, favorite: favorite)
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request!, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showFavoriteError()
                return
            }
            
            if let data = data where error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    var favoriteMovies = User.getInstance().favoriteMovies!
                    if self.isFavorite == true {
                        favoriteMovies.removeAtIndex(favoriteMovies.indexOf(movie))
                        self.btnFavorite.image = UIImage(named: "ic_favorite_border")
                    } else {
                        favoriteMovies.insert(self.movie, atIndex: 0)
                        self.btnFavorite.image = UIImage(named: "ic_favorite")
                    }
                    self.isFavorite = !self.isFavorite
                })
            }
            self.showFavoriteError()

        }).resume()
    }
    
    private func showFavoriteError() {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Error", message: "Cannot complete your request", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: { action in
                self.topBar.leftBarButtonItem?.enabled = true
                self.btnFavorite.enabled = true
            }))
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
                self.addRemoveFavorite(!self.isFavorite)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}
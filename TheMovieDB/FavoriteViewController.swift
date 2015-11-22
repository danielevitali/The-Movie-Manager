//
//  FavoriteViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewController: MoviesViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tblFavoriteMovies: UITableView!
    @IBOutlet weak var lblNoFavoriteMovies: UILabel!
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tblFavoriteMovies.hidden = true
        lblNoFavoriteMovies.hidden = true
        
        if User.getInstance().isLoggedIn() {
            btnLogin.hidden = true
            if User.getInstance().favoriteMovies == nil {
                fetchFavoriteMovies()
            } else {
                updateUI()
            }
        } else {
            btnLogin.hidden = false
        }
    }
    
    @IBAction func loginClick(sender: AnyObject) {
        performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    private func fetchFavoriteMovies() {
        activityIndicator.startAnimating()
        
        let accountId = User.getInstance().accountId!
        let request = Network.getRequestForFavoriteMovies(accountId)
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request!, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showFetchFavoriteMoviesError()
                return
            }
            
            if let data = data where error == nil {
                let moviesResponse = Network.parseMoviesResponse(data)
                var favoriteMovies = [Movie]()
                for movieResponse in moviesResponse.movies {
                    favoriteMovies.append(Movie(response: movieResponse))
                }
                User.getInstance().favoriteMovies = favoriteMovies
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.startAnimating()
                    self.updateUI()
                })
                return
            }
            self.showFetchFavoriteMoviesError()
        }).resume()
    }
    
    private func updateUI() {
        activityIndicator.stopAnimating()
        movies = User.getInstance().favoriteMovies
        if let movies = movies {
            if movies.isEmpty {
                tblFavoriteMovies.hidden = true
                lblNoFavoriteMovies.hidden = false
            } else {
                tblFavoriteMovies.hidden = false
                lblNoFavoriteMovies.hidden = true
            }
        }
        tblFavoriteMovies.reloadData()
    }
    
    private func showFetchFavoriteMoviesError() {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: "Impossible to get favorite movie list", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
                self.fetchFavoriteMovies()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}

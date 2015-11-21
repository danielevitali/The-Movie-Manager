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
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tblFavoriteMovies: UITableView!
    @IBOutlet weak var lblNoFavoriteMovies: UILabel!
    
    var activityIndicator: UIActivityIndicatorView!
    var favoriteMovies: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50))
        activityIndicator!.center = self.view.center
        activityIndicator!.hidesWhenStopped = true
        activityIndicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator!)
    }
    
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
        activityIndicator!.startAnimating()
        
        let accountId = User.getInstance().accountId!
        let url = Network.getUrlForFavoriteMovies(accountId)
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url!)
        session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showFetchFavoriteMoviesError()
                return
            }
            
            if let data = data where error == nil {
                let favoriteMoviesResponse = Network.parseFavoriteMoviesResponse(data)
                var favoriteMovies = [Movie]()
                for movieResponse in favoriteMoviesResponse.favorieMovies {
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
        favoriteMovies = User.getInstance().favoriteMovies
        if favoriteMovies != nil {
            tblFavoriteMovies.hidden = false
            lblNoFavoriteMovies.hidden = true
        } else {
            tblFavoriteMovies.hidden = true
            lblNoFavoriteMovies.hidden = false
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

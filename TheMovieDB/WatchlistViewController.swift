//
//  GenresViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/22/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblMovies: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func fetchMovies(genre: MovieGenre) {
        if self.genre == genre {
            return
        }
        
        self.genre = genre
        tblMovies.hidden = true
        activityIndicator.startAnimating()
        
        let request = Network.getRequestForMovies(withGenre: genre)
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request, completionHandler: { data, response, error in
                
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showMoviesFetchError()
                return
            }
                
            if let data = data where error == nil {
                let moviesResponse = Network.parseMoviesResponse(data)
                    
                if var movies = self.movies {
                    movies.removeAll()
                } else {
                    self.movies = [Movie]()
                }
                    
                for movieResponse in moviesResponse.movies {
                    self.movies!.append(Movie(response: movieResponse))
                }

                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicator.stopAnimating()
                    self.tblMovies.hidden = false
                    self.tblMovies.reloadData()
                })
                return
            }

            self.showMoviesFetchError()
        }).resume()
    }
    
    private func showMoviesFetchError() {
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Error", message: "Cannot fetch movies", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
                self.fetchMovies(self.genre!)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}
//
//  MoviesViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class SearchMoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tblMovies: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var activityProgress: UIActivityIndicatorView!
    
    private var movies: [Movie]?
    private var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfSearch.delegate = self
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.activityProgress.hidden = false
        NetworkManager.getInstance().searchMovies(string, completionHandler: {response, error in
            if let response = response {
                var movies = [Movie]()
                for movieResponse in response.movies {
                    movies.append(Movie(response: movieResponse))
                }
                self.movies = movies
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityProgress.hidden = true
                    self.tblMovies.reloadData()
                })
            } else {
                
            }
        })
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count;
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("searchMovieCell")! as! MovieCell
        let movie = movies![indexPath.row]
        cell.setMovie(movie)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showMovieDetails(movies![indexPath.row])
    }
    
    private func showMovieDetails(movie: Movie) {
        selectedMovie = movie
        performSegueWithIdentifier("movieDetailsSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetailsSegue" {
            let destionationViewController = segue.destinationViewController as! MovieDetailsViewController
            destionationViewController.movie = selectedMovie
        }
    }
}
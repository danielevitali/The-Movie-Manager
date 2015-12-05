//
//  MoviesViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class SearchMoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SearchMoviesContractView {
    
    @IBOutlet weak var tblMovies: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var activityProgress: UIActivityIndicatorView!

    private var presenter: SearchMoviesContractPresenter!
    private var movies: [Movie]?
    private var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchMoviesPresenter(view: self)
        tfSearch.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        presenter = nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        presenter.search(string)
        return true
    }
    
    func showMovies(movies: [Movie]) {
        self.movies = movies
        tblMovies.reloadData()
    }
    
    func toggleActivityIndicator(visible: Bool) {
        activityProgress.hidden = !visible
    }
    
    func showErrorAlert() {
        if presentedViewController != nil {
            let alert = UIAlertController(title: "Error", message: "Error retreiving the list of movies", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { action in
                self.presenter.search(self.tfSearch.text!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
    
    func showMovieDetails(movie: Movie) {
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
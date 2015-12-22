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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblEmptyList: UILabel!

    private var presenter: SearchMoviesContractPresenter!
    private var movies: [Movie]?
    private var movieForSegue: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchMoviesPresenter(view: self)
        tfSearch.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tblMovies.reloadData()
    }
    
    func showNoMovieFound() {
        tblMovies.hidden = true
        lblEmptyList.hidden = false
        lblEmptyList.text = "No movie with this title found"
    }
    
    func showInitialLabel() {
        tblMovies.hidden = true
        lblEmptyList.hidden = false
        lblEmptyList.text = "Start typing the title of a movie"
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        presenter.search(text.stringByReplacingCharactersInRange(range, withString: string))
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func showMovies(movies: [Movie]) {
        self.movies = movies
        tblMovies.reloadData()
        tblMovies.hidden = false
        lblEmptyList.hidden = true
    }
    
    func toggleActivityIndicator(animate: Bool) {
        if animate {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
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
        let cell =  tableView.dequeueReusableCellWithIdentifier("searchMovieCell")! as! SearchMovieCell
        let movie = movies![indexPath.row]
        cell.setMovie(movie)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        presenter.movieClick(movies![indexPath.row])
    }
    
    func showMovieDetails(movie: Movie) {
        movieForSegue = movie
        performSegueWithIdentifier("movieDetailsSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "movieDetailsSegue":
            let destionationViewController = segue.destinationViewController as! MovieDetailsViewController
            destionationViewController.movie = movieForSegue
            break;
        default:
            break
        }
    }
}
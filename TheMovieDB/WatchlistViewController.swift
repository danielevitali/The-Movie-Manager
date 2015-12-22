//
//  GenresViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/22/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserMovieListContractView {
    
    @IBOutlet weak var tblMovies: UITableView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblNoMovies: UILabel!
    
    private var presenter: UserMovieListContractPresenter!
    private var watchlist: [Movie]?
    private var movieForSegue: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WatchlistPresenter(view: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func showNoMovieFound() {
        lblNoMovies.hidden = false
        btnLogin.hidden = true
        tblMovies.hidden = true
    }
    
    func showLoginButton() {
        lblNoMovies.hidden = true
        btnLogin.hidden = false
        tblMovies.hidden = true
    }
    
    func showMovies(movies: [Movie]) {
        self.watchlist = movies
        tblMovies.reloadData()
        lblNoMovies.hidden = true
        btnLogin.hidden = true
        tblMovies.hidden = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let watchlist = watchlist {
            return watchlist.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("watchlistMovieCell")! as! WatchlistMovieCell
        let movie = watchlist![indexPath.row]
        cell.setMovie(movie)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let movie = watchlist![indexPath.row]
        presenter.movieClick(movie)
    }
    
    @IBAction func loginClick(sender: AnyObject) {
        presenter.loginClick()
    }
    
    func showMovieDetails(movie: Movie) {
        movieForSegue = movie
        performSegueWithIdentifier("movieDetailsSegue", sender: self)
    }
    
    func showLogin() {
        performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "movieDetailsSegue":
            let destionationViewController = segue.destinationViewController as! MovieDetailsViewController
            destionationViewController.movie = movieForSegue
            break;
        default:
            break;
        }
    }
}
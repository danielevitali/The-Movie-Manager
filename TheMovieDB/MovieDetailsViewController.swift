//
//  MovieDetailsViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/22/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailsViewController: UIViewController, MovieDetailsContractView {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    @IBOutlet weak var btnWatchlist: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movie: Movie!
    
    private var presenter: MovieDetailsContractPresenter!
    private var favorite: Bool!
    private var inWatchlist: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieDetailsPresenter(view: self)
        
        favorite = presenter.isFavoriteMovie(movie)
        if let favorite = favorite {
            btnFavorite.image = UIImage(named: "ic_favorite")
            if favorite {
                btnFavorite.style = UIBarButtonItemStyle.Plain
            } else {
                btnFavorite.style  = UIBarButtonItemStyle.Bordered
            }
        } else {
            btnFavorite.image = nil
        }
        
        inWatchlist = presenter.isInWatchlistMovie(movie)
        if let inWatchlist = inWatchlist {
            btnWatchlist.image = UIImage(named: "ic_list")
            if inWatchlist {
                btnWatchlist.style  = UIBarButtonItemStyle.Plain
            } else {
                btnWatchlist.style  = UIBarButtonItemStyle.Bordered
            }
        } else {
            btnWatchlist.image = nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let posterUrl = presenter.getPosterUrl(movie) {
            imgPoster.image = UIImage(data: NSData(contentsOfURL: posterUrl)!)
        }
        navigationItem.title = movie.title
    }
    
    @IBAction func favoriteClick(sender: AnyObject) {
        if favorite! {
            presenter.removeFromFavoriteClick(movie)
        } else {
            presenter.addToFavoriteClick(movie)
        }
    }
    
    @IBAction func watchlistClick(sender: AnyObject) {
        if inWatchlist! {
            presenter.removeFromWatchlistClick(movie)
        } else {
            presenter.addToWatchlistClick(movie)
        }
    }
    
    func toggleActivityIndicator(animate: Bool) {
        if animate {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showLogin() {
        performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    func movieAddedToFavorites() {
        favorite = true
        btnFavorite.style  = UIBarButtonItemStyle.Plain
    }
    
    func movieRemovedFromFavorites() {
        favorite = false
        btnFavorite.style  = UIBarButtonItemStyle.Bordered
    }
    
    func movieAddedToWatchlist() {
        inWatchlist = true
        btnWatchlist.style  = UIBarButtonItemStyle.Plain
    }
    
    func movieRemovedFromWatchlist() {
        inWatchlist = false
        btnWatchlist.style  = UIBarButtonItemStyle.Bordered
    }
    
    func disableWatchlistAndFavoriteButton() {
        btnWatchlist.enabled = false
        btnFavorite.enabled = false
    }
    
    func enableWatchlistAndFavoriteButton() {
        btnWatchlist.enabled = true
        btnFavorite.enabled = true
    }
    
    func showErrorAddingToFavorites() {
        let alert = UIAlertController(title: "Error", message: "Cannot add movie to your favorite", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
            self.presenter.addToFavoriteClick(self.movie)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showErrorRemovingFromFavorites() {
        let alert = UIAlertController(title: "Error", message: "Cannot remove movie from your favorite", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
            self.presenter.removeFromFavoriteClick(self.movie)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showErrorAddingToWatchlist() {
        let alert = UIAlertController(title: "Error", message: "Cannot add movie to your watchlist", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
            self.presenter.addToWatchlistClick(self.movie)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showErroRemovingFromWatchlist() {
        let alert = UIAlertController(title: "Error", message: "Cannot remove movie from your watchlist", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
            self.presenter.removeFromWatchlistClick(self.movie)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
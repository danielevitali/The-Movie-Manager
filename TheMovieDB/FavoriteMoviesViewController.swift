//
//  FavoriteViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class FavoriteMoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UserMovieListContractView {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var cvFavorites: UICollectionView!
    
    private var presenter: UserMovieListContractPresenter!
    private var favoriteMovies: [Movie]?
    private var movieForSegue: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = UserMovieListPresenter(view: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let account = Account.getInstance()
        if account.isUserLoggedIn() {
            favoriteMovies = Account.getInstance().favoriteMovies
            btnLogin.hidden = true
        } else {
            btnLogin.hidden = false
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let favoriteMovies = favoriteMovies {
            return favoriteMovies.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("favoriteMovieCell", forIndexPath: indexPath) as! FavoriteMovieCell
        let movie = favoriteMovies![indexPath.row]
        cell.setMovie(movie)
        return cell
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

//
//  MoviesViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movies: [Movie]?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let favoriteMovies = movies {
            return favoriteMovies.count;
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("movieCell")! as! MovieCell
        let movie = movies![indexPath.row]
        cell.setMovie(movie)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showMovieDetails(movies![indexPath.row])
    }
    
    private func showMovieDetails(movie: Movie) {
        
    }
}
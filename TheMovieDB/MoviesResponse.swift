//
//  FavoriteMoviesResponse.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class MoviesResponse {
    
    var movies: [MovieResponse]
    
    init(response: NSDictionary) {
        movies = [MovieResponse]()
        let list = response["results"] as! [AnyObject]
        for movie in list {
            movies.append(MovieResponse(response: movie as! NSDictionary))
        }
    }
    
}
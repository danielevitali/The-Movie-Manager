//
//  FavoriteMoviesResponse.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class FavoriteMoviesResponse {
    
    var favorieMovies: [MovieResponse]
    
    init(response: NSDictionary) {
        favorieMovies = [MovieResponse]()
        let list = response["results"] as! [AnyObject]
        for movie in list {
            favorieMovies.append(MovieResponse(response: movie as! NSDictionary))
        }
    }
    
}
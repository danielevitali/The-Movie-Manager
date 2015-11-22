//
//  FavoriteMovieRequest.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/22/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class FavoriteMovieRequest {
    
    let movieId: Int
    let favorite: Bool
    
    init(movieId: Int, favorite: Bool) {
        self.movieId = movieId
        self.favorite = favorite
    }
    
    func getJsonString() -> String{
        return "{\"media_type\":\"movie\",\"media_id\":\(movieId),\"favorite\":\(favorite)}"
    }
}
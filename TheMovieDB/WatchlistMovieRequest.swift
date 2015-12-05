//
//  WatchlistMovieRequest.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/5/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class WatchlistMovieRequest {
    
    let movieId: Int
    let watchlist: Bool
    
    init(movieId: Int, watchlist: Bool) {
        self.movieId = movieId
        self.watchlist = watchlist
    }
    
    func getJsonString() -> String{
        return "{\"media_type\":\"movie\",\"media_id\":\(movieId),\"watchlist\":\(watchlist)}"
    }
}
//
//  MovieResponse.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class MovieResponse {

    let backdropPath: String
    let id: Int
    let originalTitle: String
    let releaseDate: String
    let posterPath: String
    let title: String
    let voteAverage: Int
    let voteCount: Int
    
    init(response: NSDictionary){
        backdropPath = response["backdrop_path"] as! String
        id = response["id"] as! Int
        originalTitle = response["original_title"] as! String
        releaseDate = response["release_date"] as! String
        posterPath = response["poster_path"] as! String
        title = response["title"] as! String
        voteAverage = response["vote_average"] as! Int
        voteCount = response["vote_count"] as! Int
    }
    
}
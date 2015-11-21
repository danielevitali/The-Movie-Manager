//
//  Movie.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class Movie {
    
    let id: Int
    let title: String
    let imageUrl: String
    
    init(response: MovieResponse) {
        self.id = response.id
        self.title = response.title
        self.imageUrl = response.posterPath
    }
    
}
//
//  MovieDetailsPresenter.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/5/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class MovieDetailsPresenter: MovieDetailsContractPresenter {
    
    let view: MovieDetailsContractView
    
    init(view: MovieDetailsContractView) {
        self.view = view
    }
    
    func addToFavoriteClick(movie: Movie) {
        
    }
    
    func removeFromFavoriteClick(movie: Movie) {
        
    }
    
    func addToWatchlistClick(movie: Movie) {
        
    }
    
    func removeFromWatchlistClick(movie: Movie) {
        
    }
    
}
//
//  WatchlistContractView.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/20/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

protocol UserMovieListContractView {
    
    func showMovieDetails(movie: Movie)
    
    func showLogin()
    
    func showNoMovieFound()
    
    func showLoginButton()
    
    func showMovies(movies: [Movie])
}
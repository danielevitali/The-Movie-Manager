//
//  SearchMoviesContractView.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/5/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

protocol SearchMoviesContractView {
    
    func toggleActivityIndicator(animate: Bool)
    
    func showMovies(movies: [Movie])
    
    func showMovieDetails(movie: Movie)
    
    func showErrorAlert()
    
    func showNoMovieFound()
    
    func showInitialLabel()
}
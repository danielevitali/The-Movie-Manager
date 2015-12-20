//
//  MovieDetailsView.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/5/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

protocol MovieDetailsContractView {
    
    func toggleActivityIndicator(animate: Bool)
    
    func showLogin()
    
    func movieAddedToFavorites()
    
    func movieRemovedFromFavorites()
    
    func movieAddedToWatchlist()
    
    func movieRemovedFromWatchlist()
    
    func disableWatchlistAndFavoriteButton()
    
    func enableWatchlistAndFavoriteButton()
    
    func showErrorAddingToFavorites()
    
    func showErrorRemovingFromFavorites()
    
    func showErrorAddingToWatchlist()
    
    func showErroRemovingFromWatchlist()
    
}
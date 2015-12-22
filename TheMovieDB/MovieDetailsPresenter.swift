//
//  MovieDetailsPresenter.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/5/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class MovieDetailsPresenter: MovieDetailsContractPresenter {
    
    private let view: MovieDetailsContractView
    private let networkManager: NetworkManager
    
    required init(view: MovieDetailsContractView) {
        self.view = view
        self.networkManager = NetworkManager.getInstance()
    }
    
    func getPosterUrl(movie: Movie) -> NSURL? {
        if let imageName = movie.imageName {
            return networkManager.getUrlForImage(imageName, size: "original")
        }
        return nil
    }
    
    func isFavoriteMovie(movie: Movie) -> Bool {
        let account = Account.getInstance()
        guard account.isUserLoggedIn() else {
            return false
        }
        if let favorites = account.favoriteMovies {
            for favorite in favorites {
                if favorite.id == movie.id {
                    return true
                }
            }
        }
        return false
    }
    
    func isInWatchlistMovie(movie: Movie) -> Bool {
        let account = Account.getInstance()
        guard account.isUserLoggedIn() else {
            return false
        }
        if let watchlist = account.watchlist {
            for currentInWatchlist in watchlist {
                if currentInWatchlist.id == movie.id {
                    return true
                }
            }
        }
        return false
    }
    
    func addToFavoriteClick(movie: Movie) {
        view.toggleActivityIndicator(true)
        view.disableWatchlistAndFavoriteButton()
        
        let account = Account.getInstance()
        guard account.isUserLoggedIn() else {
            view.showLogin()
            return
        }
        
        let favoriteMovieRequest = FavoriteMovieRequest(movieId: movie.id, favorite: true)
        networkManager.postFavoriteMovies(account.sessionId!, accountId: account.id!, requestBody: favoriteMovieRequest, completionHandler: { error in
            dispatch_async(dispatch_get_main_queue()) {
                self.view.toggleActivityIndicator(false)
                self.view.enableWatchlistAndFavoriteButton()
            
                guard error != nil else {
                    self.view.showErrorAddingToFavorites()
                    return
                }
                self.view.movieAddedToFavorites()
            }
        })
    }
    
    func removeFromFavoriteClick(movie: Movie) {
        view.toggleActivityIndicator(true)
        view.disableWatchlistAndFavoriteButton()
        
        let account = Account.getInstance()
        guard account.isUserLoggedIn() else {
            view.showLogin()
            return
        }
        
        let favoriteMovieRequest = FavoriteMovieRequest(movieId: movie.id, favorite: false)
        networkManager.postFavoriteMovies(account.sessionId!, accountId: account.id!, requestBody: favoriteMovieRequest, completionHandler: { error in
            dispatch_async(dispatch_get_main_queue()) {
                self.view.toggleActivityIndicator(false)
                self.view.enableWatchlistAndFavoriteButton()
            
                guard error != nil else {
                    self.view.showErrorRemovingFromFavorites()
                    return
                }
                self.view.movieRemovedFromFavorites()
            }
        })
    }
    
    func addToWatchlistClick(movie: Movie) {
        view.toggleActivityIndicator(true)
        view.disableWatchlistAndFavoriteButton()
        
        let account = Account.getInstance()
        guard account.isUserLoggedIn() else {
            view.showLogin()
            return
        }
        
        let watchlistMovieRequest = WatchlistMovieRequest(movieId: movie.id, watchlist: true)
        networkManager.postWatchlist(account.sessionId!, accountId: account.id!, requestBody: watchlistMovieRequest, completionHandler: { error in
            dispatch_async(dispatch_get_main_queue()) {
                self.view.toggleActivityIndicator(false)
                self.view.enableWatchlistAndFavoriteButton()
            
                guard error != nil else {
                    self.view.showErrorAddingToWatchlist()
                    return
                }
                self.view.movieAddedToWatchlist()
            }
        })
    }
    
    func removeFromWatchlistClick(movie: Movie) {
        view.toggleActivityIndicator(true)
        view.disableWatchlistAndFavoriteButton()
        
        let account = Account.getInstance()
        guard account.isUserLoggedIn() else {
            view.showLogin()
            return
        }
        
        let watchlistMovieRequest = WatchlistMovieRequest(movieId: movie.id, watchlist: false)
        networkManager.postWatchlist(account.sessionId!, accountId: account.id!, requestBody: watchlistMovieRequest, completionHandler: { error in
            dispatch_async(dispatch_get_main_queue()) {
                self.view.toggleActivityIndicator(false)
                self.view.enableWatchlistAndFavoriteButton()
            
                guard error != nil else {
                    self.view.showErrorRemovingFromFavorites()
                    return
                }
                self.view.movieRemovedFromWatchlist()
            }
        })
    }
}
//
//  WatchlistPresenter.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/20/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class FavoriteMoviesPresenter: UserMovieListContractPresenter {
    
    private let view: UserMovieListContractView
    
    init(view: UserMovieListContractView) {
        self.view = view
    }
    
    func viewWillAppear() {
        let account = Account.getInstance()
        if account.isUserLoggedIn() {
            if account.favoriteMovies!.count > 0 {
                self.view.showMovies(account.favoriteMovies!)
            } else {
                self.view.showNoMovieFound()
            }
        } else {
            self.view.showLoginButton()
        }

    }
    
    func movieClick(movie: Movie) {
        view.showMovieDetails(movie)
    }
    
    func loginClick() {
        view.showLogin()
    }
    
}
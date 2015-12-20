//
//  WatchlistPresenter.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/20/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class UserMovieListPresenter: UserMovieListContractPresenter {
    
    private let view: UserMovieListContractView
    
    init(view: UserMovieListContractView) {
        self.view = view
    }
    
    func movieClick(movie: Movie) {
        view.showMovieDetails(movie)
    }
    
    func loginClick() {
        view.showLogin()
    }
    
}
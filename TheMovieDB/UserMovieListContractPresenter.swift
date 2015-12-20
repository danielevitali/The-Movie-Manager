//
//  WatchlistContractPresenter.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/20/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

protocol UserMovieListContractPresenter {
    
    func movieClick(movie: Movie)
    
    func loginClick()
}
//
//  SearchMoviesContractPresenter.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/5/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

protocol SearchMoviesContractPresenter {
    
    func search(query: String)
    
    func movieClick(movie: Movie)    
}
//
//  SearchMoviesPresenter.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/5/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class SearchMoviesPresenter: SearchMoviesContractPresenter{
    
    private let view: SearchMoviesContractView
    private let networkManager: NetworkManager
    
    init(view: SearchMoviesContractView) {
        self.view = view
        self.networkManager = NetworkManager.getInstance()
        self.view.showInitialLabel()
    }
    
    func search(query: String) {
        if query == "" {
            self.view.showMovies([Movie]())
            return
        }
        
        view.toggleActivityIndicator(true)
        networkManager.searchMovies(query, completionHandler: {response, error in
            if let response = response {
                var movies = [Movie]()
                for movieResponse in response.movies {
                    movies.append(Movie(response: movieResponse))
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.toggleActivityIndicator(false)
                    if movies.count == 0 {
                        self.view.showNoMovieFound()
                    } else {
                        self.view.showMovies(movies)
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.showErrorAlert()
                })
            }
        })
    }
    
    func movieClick(movie: Movie) {
        view.showMovieDetails(movie)
    }
    
    
}
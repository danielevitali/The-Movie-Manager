//
//  Account.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class Account {
    
    private static let instance = Account()
    
    var id: Int?
    var sessionId: String?
    var username: String?
    var name: String?
    var favoriteMovies: [Movie]?
    var watchlist: [Movie]?
    
    static func getInstance() -> Account {
        return instance
    }
    
    private init(){
    }
    
    func isUserLoggedIn() -> Bool {
        return id != nil && sessionId != nil
    }
    
    func setUserInfo(response: AccountInfoResponse) {
        id = response.id
        username = response.username
        name = response.name
        favoriteMovies = [Movie]()
        watchlist = [Movie]()
    }
    
    func clear() {
        sessionId = nil
        id = nil
        username = nil
        name = nil
        favoriteMovies = nil
        watchlist = nil

    }
    
}
//
//  Account.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class User {
    
    private static let instance = User()
    
    var accountId: Int?
    var username: String?
    var name: String?
    var favoriteMovies: [Movie]?
    
    static func getInstance() -> User {
        return instance
    }
    
    private init(){
    }
    
    func isLoggedIn() -> Bool {
        return accountId != nil
    }
    
    func setUserInfo(response: AccountInfoResponse) {
        accountId = response.id
        username = response.username
        name = response.name
    }
    
}
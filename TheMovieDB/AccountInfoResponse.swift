//
//  AccountInfoResponse.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class AccountInfoResponse {
    
    let id: Int
    let username: String
    let name: String
    
    init(response: NSDictionary) {
        id = response["id"] as! Int
        username = response["username"] as! String
        name = response["name"] as! String
    }
}
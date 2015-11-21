//
//  LoginResponse.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class LoginResponse {
    
    let requestToken: String
    let success: Bool
    
    init(response: NSDictionary) {
        requestToken = response["request_token"] as! String
        success = response["success"] as! Bool
    }
}
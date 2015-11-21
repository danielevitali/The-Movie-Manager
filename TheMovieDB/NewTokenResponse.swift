//
//  NewTokenResponse.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class NewTokenResponse {
    
    let expiresAt: String
    let requestToken: String
    let success: Bool
    
    init(response: NSDictionary) {
        expiresAt = response["expires_at"] as! String
        requestToken = response["request_token"] as! String
        success = response["success"] as! Bool
    }
}
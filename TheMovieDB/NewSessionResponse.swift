//
//  NewSessionResponse.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class NewSessionResponse {
    
    let sessionId: String
    let success: Bool
    
    init(response: NSDictionary) {
        sessionId = response["session_id"] as! String
        success = response["success"] as! Bool
    }
}
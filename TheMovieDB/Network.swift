//
//  File.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class Network {
    
    private static let API_KEY = "83a5d1c6c2e522bed6c6f758819fb687"
    private static let BASE_URL = "http://api.themoviedb.org/3"
    private static let AUTHENTICATION_PATH = "/authentication/token/new"
    
    static func getUrlForNewToken() -> NSURL {
        let params = [
            "api_key" : API_KEY
        ]
        return NSURL(string: (BASE_URL + AUTHENTICATION_PATH + escapedParameters(params)))!
    }
    
    private static func escapedParameters(parameters: [String : String]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            let escapedValue = "\(value)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (urlVars.isEmpty ? "" : "?") + urlVars.joinWithSeparator("&")
    }
}
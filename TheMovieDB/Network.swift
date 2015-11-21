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
    private static let NEW_TOKEN_PATH = "/authentication/token/new"
    private static let VALIDATE_TOKEN_PATH = "/authentication/token/new"
    private static let NEW_SESSION_PATH = "/authentication/session/new"
    
    static var sessionId: String?
    
    static func getUrlForNewToken() -> NSURL {
        let params = [
            "api_key" : API_KEY
        ]
        return NSURL(string: (BASE_URL + NEW_TOKEN_PATH + escapedParameters(params)))!
    }
    
    static func parseNewTokenResponse(data: NSData) -> NewTokenResponse {
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
        return NewTokenResponse(response: json)
    }
    
    static func getUrlForLogin(token: String, email: String, password: String) -> NSURL {
        let params = [
            "api_key" : API_KEY,
            "request_token" : token,
            "username" : email,
            "password" : password,
        ]
        return NSURL(string: (BASE_URL + VALIDATE_TOKEN_PATH + escapedParameters(params)))!
    }
    
    static func parseLoginResponse(data: NSData) -> LoginResponse {
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
        return LoginResponse(response: json)
    }
    
    static func getUrlForNewSession(token: String) -> NSURL {
        let params = [
            "api_key" : API_KEY,
            "request_token" : token
        ]
        return NSURL(string: (BASE_URL + NEW_SESSION_PATH + escapedParameters(params)))!
    }
    
    static func parseNewSessionResponse(data: NSData) -> NewSessionResponse {
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
        return NewSessionResponse(response: json)
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
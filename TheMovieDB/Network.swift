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
    
    private static let BASE_URL = "https://api.themoviedb.org/3"
    private static let NEW_TOKEN_PATH = "/authentication/token/new"
    private static let VALIDATE_TOKEN_PATH = "/authentication/token/validate_with_login"
    private static let NEW_SESSION_PATH = "/authentication/session/new"
    private static let ACCOUNT_INFO_PATH = "/account"
    private static let FAVORITE_MOVIES_PATH = "/account/{id}/favorite/movies"
    private static let MOVIES_BY_GENRE_PATH = "/genre/{id}/movies"
    
    private static let genreMap: [MovieGenre : String] = [
        .Action: "28",
        .SciFi: "878",
        .Comedy: "35"
    ]
    
    static var sessionId: String?
    
    static func getRequestForNewToken() -> NSMutableURLRequest {
        let params = [
            "api_key" : API_KEY
        ]
        let url = NSURL(string: (BASE_URL + NEW_TOKEN_PATH + escapedParameters(params)))!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func parseNewTokenResponse(data: NSData) -> NewTokenResponse {
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
        return NewTokenResponse(response: json)
    }
    
    static func getRequestForLogin(token: String, username: String, password: String) -> NSMutableURLRequest {
        let params = [
            "api_key" : API_KEY,
            "request_token" : token,
            "username" : username,
            "password" : password,
        ]
        let url = NSURL(string: (BASE_URL + VALIDATE_TOKEN_PATH + escapedParameters(params)))!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func parseLoginResponse(data: NSData) -> LoginResponse {
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
        return LoginResponse(response: json)
    }
    
    static func getRequestForNewSession(token: String) -> NSMutableURLRequest {
        let params = [
            "api_key" : API_KEY,
            "request_token" : token
        ]
        let url = NSURL(string: (BASE_URL + NEW_SESSION_PATH + escapedParameters(params)))!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func parseNewSessionResponse(data: NSData) -> NewSessionResponse {
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
        return NewSessionResponse(response: json)
    }
    
    static func getRequestForAccountInfo() -> NSMutableURLRequest? {
        if let sessionId = sessionId {
            let params = [
                "api_key" : API_KEY,
                "session_id" : sessionId
            ]
            let url = NSURL(string: (BASE_URL + ACCOUNT_INFO_PATH + escapedParameters(params)))!
            let request = NSMutableURLRequest(URL: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }
        return nil
    }
    
    static func parseAccountInfoResponse(data: NSData) -> AccountInfoResponse {
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
        return AccountInfoResponse(response: json)
    }

    static func getRequestForFavoriteMovies(accountId: Int) -> NSMutableURLRequest? {
        if let sessionId = sessionId {
            let params = [
                "api_key" : API_KEY,
                "session_id" : sessionId
            ]
            var userFavoriteMoviesPath = FAVORITE_MOVIES_PATH
            userFavoriteMoviesPath.replaceRange(FAVORITE_MOVIES_PATH.rangeOfString("{id}")!, with: String(accountId))
            let url = NSURL(string: (BASE_URL + userFavoriteMoviesPath + escapedParameters(params)))!
            let request = NSMutableURLRequest(URL: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }
        return nil
    }
    
    static func parseMoviesResponse(data: NSData) -> MoviesResponse {
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
        return MoviesResponse(response: json)
    }
    
    static func getRequestForMovies(withGenre genre: MovieGenre) -> NSMutableURLRequest {
        let params = [
            "api_key" : API_KEY
        ]
        var moviesByGenrePath = MOVIES_BY_GENRE_PATH
        moviesByGenrePath.replaceRange(MOVIES_BY_GENRE_PATH.rangeOfString("{id}")!, with: genreMap[genre]!)
        let url = NSURL(string: (BASE_URL + moviesByGenrePath + escapedParameters(params)))!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
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
//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/5/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {

    static let SEARCH_MOVIE_PATH = "/search/movie"
    static let NEW_TOKEN_PATH = "/authentication/token/new"
    static let VALIDATE_TOKEN_PATH = "/authentication/token/validate_with_login"
    static let NEW_SESSION_PATH = "/authentication/session/new"
    static let ACCOUNT_INFO_PATH = "/account"
    static let FAVORITE_MOVIES_PATH = "/account/{id}/favorite/movies"
    static let POST_FAVORITE_MOVIE_PATH = "/account/{id}/favorite"
    static let WATCHLIST_PATH = "/account/{id}/watchlist/movies"
    static let POST_WATCHLIST_PATH = "/account/{id}/watchlist"
    
    private static let API_KEY = "83a5d1c6c2e522bed6c6f758819fb687"
    private static let BASE_URL = "https://api.themoviedb.org/3"
    private static let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/{size}/{name}"

    private static var instance: NetworkManager!
    
    private let sharedSession: NSURLSession
    
    static func getInstance() -> NetworkManager {
        if instance == nil {
            instance = NetworkManager()
        }
        return instance
    }
    
    override init() {
        sharedSession = NSURLSession.sharedSession()
    }
    
    func getNewToken(completionHandler: (newTokenResponse: NewTokenResponse?, error: NSError?) -> Void) {
        let url = buildUrl(NetworkManager.NEW_TOKEN_PATH, params: nil)
        executeGetRequest(url, completionHandler: { data, error in
            if error != nil {
                completionHandler(newTokenResponse: nil, error: error)
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            completionHandler(newTokenResponse: NewTokenResponse(response: json), error: error)
        })
    }
    
    func getRequestForLogin(token: String, username: String, password: String, completionHandler: (loginResponse: LoginResponse?, error: NSError?) -> Void) {
        let params = [
            "request_token" : token,
            "username" : username,
            "password" : password,
        ]
        let url = buildUrl(NetworkManager.VALIDATE_TOKEN_PATH, params: params)
        executeGetRequest(url, completionHandler: { data, error in
            if error != nil {
                completionHandler(loginResponse: nil, error: error)
                return
            }
        
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            completionHandler(loginResponse: LoginResponse(response: json), error: nil)
        })
    }
    
    func getRequestForNewSession(token: String, completionHandler: (newSessionResponse: NewSessionResponse?, error: NSError?) -> Void) {
        let params = [
            "request_token" : token
        ]
        let url = buildUrl(NetworkManager.NEW_SESSION_PATH, params: params)
        executeGetRequest(url, completionHandler: { data, error in
            if error != nil {
                completionHandler(newSessionResponse: nil, error: error)
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            completionHandler(newSessionResponse: NewSessionResponse(response: json), error: error)
        })
    }
    
    func getAccountInfo(sessionId: String, completionHandler: (accountInfoResponse: AccountInfoResponse?, error: NSError?) -> Void) {
        let params = [
            "session_id" : sessionId
        ]
        let url = buildUrl(NetworkManager.ACCOUNT_INFO_PATH, params: params)
        executeGetRequest(url, completionHandler: { data, error in
            if error != nil {
                completionHandler(accountInfoResponse: nil, error: error)
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            completionHandler(accountInfoResponse: AccountInfoResponse(response: json), error: error)
        })
    }
    
    func searchMovies(query: String, completionHandler: (moviesResponse: MoviesResponse?, error: NSError?) -> Void) {
        let url = buildUrl(NetworkManager.SEARCH_MOVIE_PATH, params: nil)
        executeGetRequest(url, completionHandler: { data, error in
            if error != nil {
                completionHandler(moviesResponse: nil, error: error)
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            completionHandler(moviesResponse: MoviesResponse(response: json), error: error)
        })
    }
    
    func getFavoriteMovies(sessionId: String, accountId: Int, completionHandler: (moviesResponse: MoviesResponse?, error: NSError?) -> Void) {
        let params = [
            "session_id" : sessionId
        ]
        let path = buildPathWithId(NetworkManager.FAVORITE_MOVIES_PATH, id: accountId)
        let url = buildUrl(path, params: params)
        executeGetRequest(url, completionHandler: { data, error in
            if error != nil {
                completionHandler(moviesResponse: nil, error: error)
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            completionHandler(moviesResponse: MoviesResponse(response: json), error: error)
        })
    }
    
    func postFavoriteMovies(sessionId: String, accountId: Int, requestBody: FavoriteMovieRequest, completionHandler: (error: NSError?) -> Void) {
        let params = [
            "session_id" : sessionId
        ]
        let path = buildPathWithId(NetworkManager.POST_FAVORITE_MOVIE_PATH, id: accountId)
        let url = buildUrl(path, params: params)
        let bodyData = requestBody.getJsonString().dataUsingEncoding(NSUTF8StringEncoding)
        executePostRequest(url, body: bodyData!, completionHandler: { data, error in
            completionHandler(error: error)
        })
    }
    
    func getWatchlist(sessionId: String, accountId: Int, completionHandler: (moviesResponse: MoviesResponse?, error: NSError?) -> Void) {
        let params = [
            "session_id" : sessionId
        ]
        let path = buildPathWithId(NetworkManager.WATCHLIST_PATH, id: accountId)
        let url = buildUrl(path, params: params)
        executeGetRequest(url, completionHandler: { data, error in
            if error != nil {
                completionHandler(moviesResponse: nil, error: error)
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            completionHandler(moviesResponse: MoviesResponse(response: json), error: error)
        })
    }
    
    func postWatchlist(sessionId: String, accountId: Int, requestBody: WatchlistMovieRequest, completionHandler: (error: NSError?) -> Void) {
        let params = [
            "session_id" : sessionId
        ]
        let path = buildPathWithId(NetworkManager.POST_WATCHLIST_PATH, id: accountId)
        let url = buildUrl(path, params: params)
        let bodyData = requestBody.getJsonString().dataUsingEncoding(NSUTF8StringEncoding)
        executePostRequest(url, body: bodyData!, completionHandler: { data, error in
            completionHandler(error: error)
        })
    }
    
    private func buildUrl(path: String, var params: [String : String]?) -> NSURL {
        if params == nil {
            params = [String : String]()
        }
        params!["api_key"] = NetworkManager.API_KEY
        return NSURL(string: (NetworkManager.BASE_URL + path + escapedParameters(params!)))!
    }

    private func buildPathWithId(var path: String, id: Int) -> String {
        path.replaceRange(path.rangeOfString("{id}")!, with: String(id))
        return path
    }
    
    private func executeGetRequest(url: NSURL, completionHandler: (data: NSData?, error: NSError?) -> Void){
        let request = NSURLRequest(URL: url)
        sharedSession.dataTaskWithRequest(request, completionHandler: { data, response, error in
            completionHandler(data: data, error: error)
        }).resume()
    }
    
    private func executePostRequest(url: NSURL, body: NSData, completionHandler: (data: NSData?, error: NSError?) -> Void){
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = body
        sharedSession.dataTaskWithRequest(request, completionHandler: { data, response, error in
            completionHandler(data: data, error: error)
        }).resume()
    }
    
    private func escapedParameters(parameters: [String : String]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            let escapedValue = "\(value)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (urlVars.isEmpty ? "" : "?") + urlVars.joinWithSeparator("&")
    }
}
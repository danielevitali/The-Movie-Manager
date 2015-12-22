//
//  LoginPresenter.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/20/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

class LoginPresenter: LoginContractPresenter {
    
    private let view: LoginContractView
    private let networkManager: NetworkManager
    
    private var token: String?
    private var username: String?
    private var password: String?
    private var sessionId: String?
    
    init(view: LoginContractView) {
        self.view = view
        self.networkManager = NetworkManager.getInstance()
    }
    
    func closeClick() {
        view.dismissViewController()
    }
    
    func loginClick(var username: String, var password: String) {
        view.dismissWarningsForValidation()
        var validData = true
        
        username = username.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if username == "" {
            view.showWarningForInvalidUsername()
            validData = false
        }
        
        password = password.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if password == "" {
            view.showWarningForInvalidPassword()
            validData = false
        }
        
        if validData {
            self.username = username
            self.password = password
            view.disableUI()
            view.toggleActivityIndicator(true)
            requestToken()
        }
    }
    
    private func requestToken() {
        networkManager.getNewToken({ newTokenResponse, error in
            guard let newTokenResponse = newTokenResponse where newTokenResponse.success else {
                self.errorDuringLogin()
                return
            }
            
            self.token = newTokenResponse.requestToken
            self.login()
        })
    }
    
    private func login() {
        networkManager.getRequestForLogin(token!, username: username!, password: password!) { loginResponse, error in
            guard let loginResponse = loginResponse where loginResponse.success else {
                self.errorDuringLogin()
                return
            }
            
            self.newSession()
        }
    }
    
    private func newSession() {
        networkManager.getRequestForNewSession(token!) { newSessionResponse, error in
            guard let newSessionResponse = newSessionResponse where newSessionResponse.success else {
                self.errorDuringLogin()
                return
            }
            
            self.sessionId = newSessionResponse.sessionId
            self.getUserInfo()
        }
    }
    
    private func getUserInfo() {
        networkManager.getAccountInfo(sessionId!) { accountInfoResponse, error in
            guard let accountInfoResponse = accountInfoResponse else {
                self.errorDuringLogin()
                return
            }
            
            let account = Account.getInstance()
            account.setUserInfo(accountInfoResponse)
            account.sessionId = self.sessionId!
            self.getUserFavoriteMovies()
        }
    }
    
    private func getUserFavoriteMovies() {
        networkManager.getFavoriteMovies(sessionId!, accountId: Account.getInstance().id!, completionHandler: { moviesResponse, error in
            guard let moviesResponse = moviesResponse else {
                self.errorDuringLogin()
                return
            }
            
            let account = Account.getInstance()
            for movieResponse in moviesResponse.movies {
                account.favoriteMovies?.append(Movie(response: movieResponse))
            }
            self.getUserWatchlist()
        })
    }
    
    private func getUserWatchlist() {
        networkManager.getWatchlist(sessionId!, accountId: Account.getInstance().id!, completionHandler: { moviesResponse, error in
            guard let moviesResponse = moviesResponse else {
                self.errorDuringLogin()
                return
            }
            
            let account = Account.getInstance()
            for movieResponse in moviesResponse.movies {
                account.watchlist?.append(Movie(response: movieResponse))
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.view.dismissViewController()
            }
        })
    }
    
    private func errorDuringLogin() {
        dispatch_async(dispatch_get_main_queue()) {
            self.view.toggleActivityIndicator(false)
            self.view.enableUI()
            self.view.showErrorDuringLogin()
            Account.getInstance().clear()
        }
    }
    
}
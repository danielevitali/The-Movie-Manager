//
//  LoginViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var username: String?
    var password: String?
    var userToken: String?
    var tapRecognizer: UITapGestureRecognizer!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        view.removeGestureRecognizer(tapRecognizer)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func closeClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func loginClick(sender: AnyObject) {
        username = tfUsername.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if let email = username where email != "" {
            tfUsername.rightView = nil
        } else {
            showWarning(tfUsername)
            username = nil
        }
        
        password = tfPassword.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if let password = password where password != "" {
            tfPassword.rightView = nil
        } else {
            showWarning(tfPassword)
            password = nil
        }
        
        if username != nil && password != nil {
            tfUsername.enabled = false
            tfPassword.enabled = false
            btnLogin.enabled = false
            activityIndicator.startAnimating()
            requestToken()
        }
    }
    
    private func showWarning(textField: UITextField) {
        let ivWarning = UIImageView(image: UIImage(named:"ic_error")!)
        var imageSize = CGSize()
        imageSize = ivWarning.sizeThatFits(imageSize)
        ivWarning.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        textField.rightView = ivWarning
    }
    
    private func requestToken() {
        let request = Network.getRequestForNewToken()
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showLoginError()
                return
            }
            
            if let data = data where error == nil {
                let newTokenResponse = Network.parseNewTokenResponse(data)
                if newTokenResponse.success {
                    self.userToken = newTokenResponse.requestToken
                    self.login()
                    return
                }
            }
            self.showLoginError()
        }).resume()
    }
    
    private func login() {
        let request = Network.getRequestForLogin(userToken!, username: username!, password: password!)
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showLoginError()
                return
            }
            
            if let data = data where error == nil {
                let loginResponse = Network.parseLoginResponse(data)
                if loginResponse.success {
                    self.newSession()
                    return
                }
            }
            self.showLoginError()
        }).resume()
    }
    
    private func newSession() {
        let request = Network.getRequestForNewSession(userToken!)
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showLoginError()
                return
            }
            
            if let data = data where error == nil {
                let newSessionResponse = Network.parseNewSessionResponse(data)
                if newSessionResponse.success {
                    Network.sessionId = newSessionResponse.sessionId
                    self.getUserInfo()
                    return
                }
            }
            self.showLoginError()
        }).resume()
    }
    
    private func getUserInfo() {
        let request = Network.getRequestForAccountInfo()
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request!, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showLoginError()
                return
            }
            
            if let data = data where error == nil {
                let accountInfoResponse = Network.parseAccountInfoResponse(data)
                User.getInstance().setUserInfo(accountInfoResponse)
                self.activityIndicator.stopAnimating()
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            }
            self.showLoginError()
        }).resume()
    }
    
    private func showLoginError() {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.activityIndicator.stopAnimating()
            
            let alert = UIAlertController(title: "Error", message: "Login failed", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: { action in
                self.btnLogin.enabled = true
                self.tfUsername.enabled = true
                self.tfPassword.enabled = true
            }))
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
                self.requestToken()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}
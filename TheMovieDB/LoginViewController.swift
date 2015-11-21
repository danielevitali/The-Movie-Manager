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
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    var email: String?
    var password: String?
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
        email = tfEmail.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if let email = email where email != "" {
            tfEmail.rightView = nil
        } else {
            showWarning(tfEmail)
            email = nil
        }
        
        password = tfPassword.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if let password = password where password != "" {
            tfPassword.rightView = nil
        } else {
            showWarning(tfPassword)
            password = nil
        }
        
        if email != nil && password != nil {
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
        let url = Network.getUrlForNewToken()
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showLoginError()
                return
            }
            
            if let data = data where error == nil {
                let newTokenResponse = Network.parseNewTokenResponse(data)
                if newTokenResponse.success {
                    self.login(newTokenResponse.requestToken)
                    return
                }
            }
            self.showLoginError()
        })
        task.resume()
    }
    
    private func login(token: String) {
        let url = Network.getUrlForLogin(token, email: email!, password: password!)
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showLoginError()
                return
            }
            
            if let data = data where error == nil {
                let loginResponse = Network.parseLoginResponse(data)
                if loginResponse.success {
                    self.newSession(loginResponse.requestToken)
                    return
                }
            }
            self.showLoginError()
        })
        task.resume()
    }
    
    private func newSession(token: String) {
        let url = Network.getUrlForNewSession(token)
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            
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
        })
        task.resume()
    }
    
    private func getUserInfo() {
        let url = Network.getUrlForAccountInfo()
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url!)
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                self.showLoginError()
                return
            }
            
            if let data = data where error == nil {
                let accountInfoResponse = Network.parseAccountInfoResponse(data)
                User.getInstance().setUserInfo(accountInfoResponse)
                return
            }
            self.showLoginError()
        })
        task.resume()
    }
    
    private func showLoginError() {
        dispatch_async(dispatch_get_main_queue(), {
            let alert = UIAlertController(title: "Error", message: "Login failed", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
                self.requestToken()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
}
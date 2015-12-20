//
//  LoginViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, LoginContractView {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnClose: UIBarButtonItem!
    
    private var presenter: LoginContractPresenter!
    var username: String?
    var password: String?
    var userToken: String?
    var tapRecognizer: UITapGestureRecognizer!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presenter = LoginPresenter(view: self)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        presenter = nil
        
        view.removeGestureRecognizer(tapRecognizer)
    }
    
    func toggleActivityIndicator(animate: Bool) {
        if animate {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func closeClick(sender: AnyObject) {
        presenter.closeClick()
    }
    
    @IBAction func loginClick(sender: AnyObject) {
        presenter.loginClick(tfUsername.text!, password: tfPassword.text!)
    }
    
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showWarningForInvalidUsername() {
        showWarning(tfUsername)
    }
    
    func showWarningForInvalidPassword() {
        showWarning(tfPassword)
    }
    
    func dismissWarningsForValidation() {
        tfUsername.rightView = nil
        tfPassword.rightView = nil
    }
    
    func showErrorDuringLogin() {
        self.activityIndicator.stopAnimating()
        
        let alert = UIAlertController(title: "Error", message: "Login failed", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { action in
            self.presenter.loginClick(self.tfUsername.text!, password: self.tfPassword.text!)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func disableUI() {
        btnLogin.enabled = false
        tfUsername.enabled = false
        tfPassword.enabled = false
        btnClose.enabled = false
    }
    
    func enableUI() {
        btnLogin.enabled = true
        tfUsername.enabled = true
        tfPassword.enabled = true
        btnClose.enabled = true
    }
    
    private func showWarning(textField: UITextField) {
        let ivWarning = UIImageView(image: UIImage(named:"ic_error")!)
        var imageSize = CGSize()
        imageSize = ivWarning.sizeThatFits(imageSize)
        ivWarning.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        textField.rightView = ivWarning
    }
}
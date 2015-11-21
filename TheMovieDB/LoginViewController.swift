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
    
    var tapRecognizer: UITapGestureRecognizer
    
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
    
    @IBAction func loginClick(sender: AnyObject) {
        let email = tfEmail.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if let email = email where email != "" {
            tfEmail.rightView = nil
        } else {
            showWarning(tfEmail)
        }
        
        let password = tfPassword.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if let password = password where password != "" {
            tfPassword.rightView = nil
        } else {
            showWarning(tfPassword)
        }
        
        if tfEmail.rightView != "" && tfPassword.rightView != "" {
            login(email!, password: password!)
        }
    }
    
    private func showWarning(textField: UITextField) {
        let ivWarning = UIImageView(image: UIImage(named:"ic_error")!)
        var imageSize = CGSize()
        imageSize = ivWarning.sizeThatFits(imageSize)
        ivWarning.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        textField.rightView = ivWarning
    }
    
    func login(email: String, password: String) {
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: Network.getUrlForNewToken())
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            
        })
        task.resume()
    }
}
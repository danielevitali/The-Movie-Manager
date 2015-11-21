//
//  FavoriteViewController.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController {
    
    @IBAction func loginClick(sender: AnyObject) {
        performSegueWithIdentifier("loginSegue", sender: self)
    }
}

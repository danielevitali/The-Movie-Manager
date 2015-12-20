//
//  LoginContractView.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/20/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation

protocol LoginContractView {
 
    func toggleActivityIndicator(animate: Bool)
    
    func dismissViewController()
    
    func showErrorDuringLogin()
    
    func showWarningForInvalidUsername()
    
    func showWarningForInvalidPassword()
    
    func dismissWarningsForValidation()
    
    func disableUI()
    
    func enableUI()
}
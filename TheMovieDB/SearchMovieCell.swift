//
//  MovieCell.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class SearchMovieCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    func setMovie(movie: Movie) {
        lblTitle.text = movie.title
    }
    
}
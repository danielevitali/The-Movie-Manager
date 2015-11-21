//
//  MovieCell.swift
//  TheMovieDB
//
//  Created by Daniele Vitali on 11/21/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    func setMovie(movie: Movie) {
        let posterImage = UIImage(data: NSData(contentsOfURL: NSURL(string: movie.imageUrl)!)!)
        imgPoster.image = posterImage
        lblTitle.text = movie.title
    }
    
}
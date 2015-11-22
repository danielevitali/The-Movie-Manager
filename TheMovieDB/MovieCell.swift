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
        let url = Network.getUrlForImage(movie.imageName, size: "w300")
        let posterImage = UIImage(data: NSData(contentsOfURL: url)!)
        imgPoster.image = posterImage
        lblTitle.text = movie.title
    }
    
}
//
//  WatchlistMovieCell.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/20/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class WatchlistMovieCell: UITableViewCell {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    func setMovie(movie: Movie) {
        if let imageName = movie.imageName {
            let url = NetworkManager.getInstance().getUrlForImage(imageName, size: "w300")
            let posterImage = UIImage(data: NSData(contentsOfURL: url)!)
            imgPoster.image = posterImage
        }
        lblTitle.text = movie.title
    }
    
}
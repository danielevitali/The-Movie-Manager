//
//  FavoriteMovieCell.swift
//  TheMovieManager
//
//  Created by Daniele Vitali on 12/20/15.
//  Copyright © 2015 Daniele Vitali. All rights reserved.
//

import Foundation
import UIKit

class FavoriteMovieCell: UICollectionViewCell {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    func setMovie(movie: Movie) {
        let url = NetworkManager.getInstance().getUrlForImage(movie.imageName, size: "w300")
        let posterImage = UIImage(data: NSData(contentsOfURL: url)!)
        imgPoster.image = posterImage
        lblTitle.text = movie.title
    }
    
}
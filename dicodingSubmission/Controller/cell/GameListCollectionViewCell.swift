//
//  GameListCollectionViewCell.swift
//  dicodingSubmission
//
//  Created by danny santoso on 26/07/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit

class GameListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gameView: GameListCollectionViewCell!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameRatting: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameReleaseDate: UILabel!
    var onReuse: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func prepareForReuse() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        gameImage.image = nil
        gameImage.cancelImageLoad()
    }

}

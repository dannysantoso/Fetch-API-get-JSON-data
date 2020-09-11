//
//  FavoriteCollectionViewCell.swift
//  dicodingSubmission
//
//  Created by danny santoso on 05/09/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameRatting: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameReleaseDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

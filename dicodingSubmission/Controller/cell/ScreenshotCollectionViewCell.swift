//
//  ScreenshotCollectionViewCell.swift
//  dicodingSubmission
//
//  Created by danny santoso on 28/07/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit

class ScreenshotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var screenshot: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        screenshot.image = nil
        screenshot.cancelImageLoad()
    }

}

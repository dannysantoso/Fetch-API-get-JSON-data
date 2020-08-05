//
//  imageView+Extension.swift
//  dicodingSubmission
//
//  Created by danny santoso on 03/08/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill, activityIndicator: UIActivityIndicatorView) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill, activityIndicator: UIActivityIndicatorView) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, activityIndicator: activityIndicator)
    }
    
    func loadImage(at url: URL, activityIndicator: UIActivityIndicatorView) {
        UIImageLoader.loader.load(url, activityIndicator: activityIndicator, for: self)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}

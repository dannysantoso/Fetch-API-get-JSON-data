//
//  DetailViewController.swift
//  dicodingSubmission
//
//  Created by danny santoso on 28/07/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var screenshotCollectionView: UICollectionView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gameReleaseDate: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    var gameData = [GameData]()
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        genreCollectionView.dataSource = self
        screenshotCollectionView.dataSource = self
        genreCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "genreCell")
        screenshotCollectionView.register(UINib(nibName: "ScreenshotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ssCell")
        
        gameImage.layer.cornerRadius = 10
        
        
        gameTitle.text = gameData[index].title
        gameRating.text = String(gameData[index].rating)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        gameReleaseDate.text = dateFormatter.string(from: gameData[index].releaseDate)
    
        gameImage.downloaded(from: gameData[index].image, activityIndicator: activityIndicator)
    }
}

extension DetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == screenshotCollectionView {
            return gameData[index].screenshot.count
        }else{
            return gameData[index].genre.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == screenshotCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ssCell", for: indexPath) as! ScreenshotCollectionViewCell
            
            cell.activityIndicator.startAnimating()
            cell.screenshot.loadImage(at: URL(string: gameData[index].screenshot[indexPath.row].image)!, activityIndicator: cell.activityIndicator)
            cell.screenshot.layer.cornerRadius = 10
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCollectionViewCell
            
            cell.genreName.text = gameData[index].genre[indexPath.row].name
            cell.genreView.layer.cornerRadius = 10
            
            return cell
        }
    }
}

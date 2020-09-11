//
//  FavoriteViewController.swift
//  dicodingSubmission
//
//  Created by danny santoso on 05/09/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    var favGamedata = [Favorite](){
        didSet{
            favoriteCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        favoriteCollectionView.isUserInteractionEnabled = true
        favoriteCollectionView.register(UINib(nibName: "FavoriteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "favoriteCell")
    }
}

extension FavoriteViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favGamedata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteCollectionViewCell
        
        
        cell.gameTitle.text = favGamedata[indexPath.row].title
        cell.activityIndicator.style = .large
        cell.activityIndicator.startAnimating()
        
        
        if let data = favGamedata[indexPath.row].image {
            cell.gameImage.image = UIImage(data: data)
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
        }
        
        
        cell.gameRatting.text = String(favGamedata[indexPath.row].ratting)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cell.gameReleaseDate.text = dateFormatter.string(from: favGamedata[indexPath.row].date!)
        
        cell.gameImage.layer.cornerRadius = 13
        cell.gameView.layer.cornerRadius = 13

        return cell
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = DetailViewController(nibName: "DetailViewController", bundle: nil)
        
        destination.favGamedata = favGamedata
        destination.segueFromFavorite = true
        destination.index = indexPath.row
        destination.selectedFavorite = favGamedata[indexPath.row]
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
}

extension FavoriteViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favGamedata = Favorite.fetchAll(viewContext: self.getViewContext())
        if favGamedata.isEmpty{
            alertLabel.isHidden = false
        }else{
            alertLabel.isHidden = true
        }
        favoriteCollectionView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

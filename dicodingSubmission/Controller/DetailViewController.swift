//
//  DetailViewController.swift
//  dicodingSubmission
//
//  Created by danny santoso on 28/07/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit
import UserNotifications

class DetailViewController: UIViewController {

    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var screenshotCollectionView: UICollectionView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gameReleaseDate: UILabel!
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    var gameData = [GameData]()
    var favGamedata = [Favorite]()
    var favScreenShot = [FavoriteScreenshot]()
    var favGenre = [FavoriteGenre]()
    var index = 0
    var isFavorite = false
    var segueFromFavorite = false
    var selectedFavorite: Favorite?
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestNotification()
        
        
        genreCollectionView.dataSource = self
        screenshotCollectionView.dataSource = self
        genreCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "genreCell")
        screenshotCollectionView.register(UINib(nibName: "ScreenshotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ssCell")
        
        gameImage.layer.cornerRadius = 10
        
        if segueFromFavorite == false{
            if Favorite.fetchQuery(viewContext: self.getViewContext(), title: gameData[index].title).isEmpty == false{
                isFavorite = true
                favoriteBtn.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            
            
            activityIndicator.startAnimating()
            gameTitle.text = gameData[index].title
            gameRating.text = String(gameData[index].rating)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            gameReleaseDate.text = dateFormatter.string(from: gameData[index].releaseDate)
            
            gameImage.downloaded(from: gameData[index].image, activityIndicator: activityIndicator)
        }else{
            if let favorite = selectedFavorite{
                favScreenShot = FavoriteScreenshot.fetchQuery(viewContext: self.getViewContext(), selectedFavorite: favorite.title!)
                favGenre = FavoriteGenre.fetchQuery(viewContext: self.getViewContext(), selectedFavorite: favorite.title!)
            }
            
            gameTitle.text = favGamedata[index].title
            gameRating.text = String(favGamedata[index].ratting)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = favGamedata[index].date{
                gameReleaseDate.text = dateFormatter.string(from: date)
            }
            
            if let data = favGamedata[index].image{
                gameImage.image = UIImage(data: data)
            }
            
            isFavorite = true
            favoriteBtn.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
    }
    
    func requestNotification(){
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Menangani eror di sini.
            }
            if granted {
                print("Allowed")
            } else {
                print("No")
            }
        }
    }
    
    @IBAction func favoriteBtn(_ sender: Any) {
        if isFavorite == true {
            if segueFromFavorite == false{
                favGamedata = Favorite.fetchQuery(viewContext: self.getViewContext(), title: gameData[index].title)
                Favorite.deleteData(viewContext: getViewContext(), favorite: favGamedata, indexFavorite: 0)
                for (i,_) in favScreenShot.enumerated() {
                    _ = FavoriteScreenshot.deleteData(viewContext: self.getViewContext(), screenshot: favScreenShot, index: i)
                }
                
                for (i,_) in favGenre.enumerated() {
                    _ = FavoriteGenre.deleteData(viewContext: self.getViewContext(), genre: favGenre, index: i)
                }
                favoriteBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                isFavorite = false
            }else{
                Favorite.deleteData(viewContext: getViewContext(), favorite: favGamedata, indexFavorite: index)
                for (i,_) in favScreenShot.enumerated() {
                    _ = FavoriteScreenshot.deleteData(viewContext: self.getViewContext(), screenshot: favScreenShot, index: i)
                }
                
                for (i,_) in favGenre.enumerated() {
                    _ = FavoriteGenre.deleteData(viewContext: self.getViewContext(), genre: favGenre, index: i)
                }
                favoriteBtn.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                isFavorite = false
                navigationController?.popViewController(animated: true)
            }
        }else{
            if segueFromFavorite == false{
                if let image = gameImage.image?.pngData(){
                    print(gameData[index].title)
                    if let favorite = Favorite.save(viewContext: self.getViewContext(), title: gameData[index].title, date: gameData[index].releaseDate, rate: Float(gameData[index].rating), image: image){
                        
                        for (i,_) in gameData[index].screenshot.enumerated() {
                            if let favS = FavoriteScreenshot.save(viewContext: getViewContext(), url: gameData[index].screenshot[i].image, selectedFavorite: favorite){
                                if favScreenShot.count != gameData[index].screenshot.count{
                                    favScreenShot += [favS]
                                }
                                
                            }
                            
                        }
                        
                        for (i,_) in gameData[index].genre.enumerated() {
                            if let favG = FavoriteGenre.save(viewContext: getViewContext(), genreName: gameData[index].genre[i].name, selectedFavorite: favorite){
                                if favGenre.count != gameData[index].genre.count{
                                    favGenre += [favG]
                                }
                            }
                        }
                    
                    }
                    
                }
            }
            favoriteBtn.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            isFavorite = true
            favoriteNotification()
        }
        
    }
    
    func favoriteNotification(){
        let content = UNMutableNotificationContent()
        content.title = "You Just Favorited Some Game"
        content.body = "\(gameTitle.text!) has been added to your Favorite"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension DetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == screenshotCollectionView {
            if segueFromFavorite == false{
                return gameData[index].screenshot.count
            }else{
                return favScreenShot.count
            }
            
        }else{
            if segueFromFavorite == false{
                return gameData[index].genre.count
            }else{
                return favGenre.count
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == screenshotCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ssCell", for: indexPath) as! ScreenshotCollectionViewCell
            
            if segueFromFavorite == false{
                cell.activityIndicator.startAnimating()
                cell.screenshot.loadImage(at: URL(string: gameData[index].screenshot[indexPath.row].image)!, activityIndicator: cell.activityIndicator)
                
            }else{
                if let image = favScreenShot[indexPath.row].url{
                    cell.activityIndicator.startAnimating()
                    cell.screenshot.loadImage(at: URL(string: image)!, activityIndicator: cell.activityIndicator)
                }
            }
            
            cell.screenshot.layer.cornerRadius = 10
            
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCollectionViewCell
            
            if segueFromFavorite == false{
                cell.genreName.text = gameData[index].genre[indexPath.row].name
            }else{
                cell.genreName.text = favGenre[indexPath.row].name
            }
            
            cell.genreView.layer.cornerRadius = 10
            
            return cell
        }
    }
}

extension DetailViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
}

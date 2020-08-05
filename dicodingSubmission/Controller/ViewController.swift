//
//  ViewController.swift
//  dicodingSubmission
//
//  Created by danny santoso on 26/07/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameCollectionView: UICollectionView!
    
    var components = URLComponents(string: "https://api.rawg.io/api/games")!
    var gamedata = [GameData]()
    var loader = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gameCollectionView.dataSource = self
        gameCollectionView.delegate = self
        gameCollectionView.isUserInteractionEnabled = true
        gameCollectionView.register(UINib(nibName: "GameListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "gameCell")
        
        
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, let data = data else { return }
            
            if response.statusCode == 200 {
                self.decodeJSON(data: data)
                
                
            } else {
                print("ERROR: \(data), HTTP Status: \(response.statusCode)")
            }
            
            
        }
        
        task.resume()
    }
    
    func decodeJSON(data: Data) {
        let decoder = JSONDecoder()
        
        guard let games = try? decoder.decode(Game.self, from: data) else{
            return
        }
        
        games.gameData.forEach { games in
            gamedata.append(games)
        }
        
        DispatchQueue.main.async {
            self.gameCollectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gamedata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GameListCollectionViewCell
        
        
        cell.gameTitle.text = gamedata[indexPath.row].title
        cell.activityIndicator.style = .large
        cell.activityIndicator.startAnimating()
        
        
        cell.gameImage.loadImage(at: URL(string: gamedata[indexPath.row].image)!, activityIndicator: cell.activityIndicator)
        
        
        cell.gameRatting.text = String(gamedata[indexPath.row].rating)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cell.gameReleaseDate.text = dateFormatter.string(from: gamedata[indexPath.row].releaseDate)
        
        cell.gameImage.layer.cornerRadius = 13
        cell.gameView.layer.cornerRadius = 13

        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = DetailViewController(nibName: "DetailViewController", bundle: nil)
        
        destination.gameData = gamedata
        destination.index = indexPath.row
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
}

extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

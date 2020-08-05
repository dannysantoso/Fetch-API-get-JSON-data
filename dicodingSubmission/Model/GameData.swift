//
//  GameData.swift
//  dicodingSubmission
//
//  Created by danny santoso on 27/07/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation
import UIKit


struct GameData: Codable {
    let rating: Double
    let image: String
    let title: String
    
    let releaseDate: Date
    let genre: [Genre]
    let screenshot: [ScreenShot]
    
    enum CodingKeys: String, CodingKey {
        case rating
        case image = "background_image"
        case title = "name"
        
        case releaseDate = "released"
        case genre = "genres"
        case screenshot = "short_screenshots"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let path = try container.decode(String.self, forKey: .image)
        
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)!
        
        rating = try container.decode(Double.self, forKey: .rating)
  
        image = path
        
        title = try container.decode(String.self, forKey: .title)
        
        releaseDate = date
        
        genre = try container.decode(Array.self, forKey: .genre)
        screenshot = try container.decode(Array.self, forKey: .screenshot)
    }
}

struct Genre: Codable {
    let name: String
}



struct ScreenShot: Codable {
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case image = "image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let path = try container.decode(String.self, forKey: .image)
        image = path
    }
}

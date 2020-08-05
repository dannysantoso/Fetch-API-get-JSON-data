//
//  Game.swift
//  dicodingSubmission
//
//  Created by danny santoso on 27/07/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation


struct Game: Codable {
    let count: Int
    let gameData: [GameData]
    
    enum CodingKeys: String, CodingKey {
        case count
        case gameData = "results"
    }
}

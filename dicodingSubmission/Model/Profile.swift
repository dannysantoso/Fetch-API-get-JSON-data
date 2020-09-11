//
//  Profile.swift
//  dicodingSubmission
//
//  Created by danny santoso on 06/09/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation

struct Profile{
    static let nameKey = "name"
    static let professionKey = "profession"
    
    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }
    
    static var profession: String {
        get {
            return UserDefaults.standard.string(forKey: professionKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: professionKey)
        }
    }
    
    static func synchronize(){
        UserDefaults.standard.synchronize()
    }
}

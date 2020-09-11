//
//  FavoriteScreenshot+Extension.swift
//  dicodingSubmission
//
//  Created by danny santoso on 05/09/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation
import CoreData

extension FavoriteScreenshot{
    
    static func fetchAll(viewContext: NSManagedObjectContext) -> [FavoriteScreenshot] {
        
        
        let request: NSFetchRequest<FavoriteScreenshot> = FavoriteScreenshot.fetchRequest()
        guard let result = try? viewContext.fetch(request) else{
            return []
        }
        return result
    }
    
    static func fetchQuery(viewContext: NSManagedObjectContext, selectedFavorite: String, predicate: NSPredicate? = nil) -> [FavoriteScreenshot]{
        let request: NSFetchRequest<FavoriteScreenshot> = FavoriteScreenshot.fetchRequest()
        
        let screenshotpredicate = NSPredicate(format: "favoriteOf.title MATCHES %@", selectedFavorite)
        
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [screenshotpredicate, addtionalPredicate])
        } else {
            request.predicate = screenshotpredicate
        }
        
        guard let result = try? viewContext.fetch(request) else{
            return []
        }
        return result
        
    }
    
    static func save(viewContext: NSManagedObjectContext, url: String, selectedFavorite: Favorite) -> FavoriteScreenshot? {
        let screenshot = FavoriteScreenshot(context: viewContext)
        screenshot.favoriteOf = selectedFavorite
        screenshot.url = url
        
        do {
          try viewContext.save()
            return screenshot
        } catch {
           return nil
        }
    }
    
    
    static func deleteData(viewContext: NSManagedObjectContext, screenshot: [FavoriteScreenshot], index: Int){
        viewContext.delete(screenshot[index])
        
        do {
            try viewContext.save()
        } catch {
           
        }
    }
}

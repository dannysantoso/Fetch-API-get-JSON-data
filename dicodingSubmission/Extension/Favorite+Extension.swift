//
//  Favorite+Extension.swift
//  dicodingSubmission
//
//  Created by danny santoso on 05/09/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation
import CoreData

extension Favorite{

    static func fetchQuery(viewContext: NSManagedObjectContext, title: String, predicate: NSPredicate? = nil) -> [Favorite]{
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        let favoritepredicate = NSPredicate(format: "title = %@", title)
        
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [favoritepredicate, addtionalPredicate])
        } else {
            request.predicate = favoritepredicate
        }
        
        guard let result = try? viewContext.fetch(request) else{
            return []
        }
        return result
        
    }
    
    
    static func fetchAll(viewContext: NSManagedObjectContext) -> [Favorite] {
        
        
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let result = try? viewContext.fetch(request) else{
            return []
        }
        return result
    }
    
    
    static func save(viewContext: NSManagedObjectContext, title: String, date:Date, rate:Float, image:Data) -> Favorite? {
        let favorite = Favorite(context: viewContext)
        favorite.title = title
        favorite.date = date
        favorite.image = image
        favorite.ratting = rate
        
        do {
            try viewContext.save()
            return favorite
        } catch  {
            return nil
        }
        
    }
    
    static func deleteData(viewContext: NSManagedObjectContext, favorite: [Favorite], indexFavorite: Int){
        viewContext.delete(favorite[indexFavorite])
        
        do {
            try viewContext.save()
        } catch {
            
        }
    }

}

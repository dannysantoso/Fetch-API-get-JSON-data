//
//  FavoriteGenre+Extension.swift
//  dicodingSubmission
//
//  Created by danny santoso on 05/09/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation
import CoreData

extension FavoriteGenre{
    
    static func fetchQuery(viewContext: NSManagedObjectContext, selectedFavorite: String, predicate: NSPredicate? = nil) -> [FavoriteGenre]{
        let request: NSFetchRequest<FavoriteGenre> = FavoriteGenre.fetchRequest()
        
        let genrepredicate = NSPredicate(format: "favoriteOf.title MATCHES %@", selectedFavorite)
        
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [genrepredicate, addtionalPredicate])
        } else {
            request.predicate = genrepredicate
        }
        
        guard let result = try? viewContext.fetch(request) else{
            return []
        }
        return result
        
    }
    
    static func save(viewContext: NSManagedObjectContext, genreName: String, selectedFavorite: Favorite) -> FavoriteGenre? {
        let genre = FavoriteGenre(context: viewContext)
        genre.favoriteOf = selectedFavorite
        genre.name = genreName
        
        do {
          try viewContext.save()
            return genre
        } catch {
           return nil
        }
    }
    
    static func deleteData(viewContext: NSManagedObjectContext, genre: [FavoriteGenre], index: Int){
        viewContext.delete(genre[index])
        
        do {
            try viewContext.save()
        } catch {
           
        }
    }
    
}

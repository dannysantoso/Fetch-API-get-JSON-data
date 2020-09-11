//
//  UIViewController+Extension.swift
//  dicodingSubmission
//
//  Created by danny santoso on 05/09/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIViewController{
    func getViewContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let container = appDelegate?.persistentContainer
        return container!.viewContext
    }
}


//
//  AbstractManager.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 16/12/2020.
//

import Foundation
import UIKit
import CoreData

class Manager {
    
    var appDelegate: AppDelegate
    var context: NSManagedObjectContext
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func executeRequest<T>(_ request: NSFetchRequest<T>) -> [T]? {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController.fetchedObjects
        } catch {
            print(error)
        }
        return nil
    }
}

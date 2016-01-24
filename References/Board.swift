//
//  Board.swift
//  References
//
//  Created by Ricardo Boccato Alves on 1/22/16.
//  Copyright © 2016 Ricardo Boccato Alves. All rights reserved.
//

import CoreData
import Foundation

class Board : NSManagedObject {
    
    struct Keys {
        static let Title = "title"
    }
    
    @NSManaged var title: String
    
    // Swift doesn't automatically inherits init methods, we must be explicit.
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // Insert the new Board into a Core Data Managed Object Context and
    // initialize its properties.
    init(title: String, context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Board", inManagedObjectContext: context)!
        
        // This inherited init method does the work of "inserting" our object
        // into the context that was passed in as a parameter.
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.title = title
    }
}

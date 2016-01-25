//
//  File.swift
//  References
//
//  Created by Ricardo Boccato Alves on 1/24/16.
//  Copyright © 2016 Ricardo Boccato Alves. All rights reserved.
//

import CoreData

class File : NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var board: Board
    
    // Swift doesn't automatically inherits init methods, we must be explicit.
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // Insert the new Board into a Core Data Managed Object Context and
    // initialize its properties.
    init(id: String, board: Board, context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("File", inManagedObjectContext: context)!
        
        // This inherited init method does the work of "inserting" our object
        // into the context that was passed in as a parameter.
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = id
        self.board = board
    }
    
}

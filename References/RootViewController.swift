//
//  ViewController.swift
//  References
//
//  Created by Ricardo Boccato Alves on 1/19/16.
//  Copyright © 2016 Ricardo Boccato Alves. All rights reserved.
//

import CoreData
import UIKit

class RootViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create edit and add butttons.
        navigationItem.leftBarButtonItem = self.editButtonItem()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addBoard")
        
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func addBoard() {
        let handler = {(title: String) -> Void in
            guard title != "" else {
                return
            }
            let board = Board(title: title, context: self.sharedContext)
            CoreDataStackManager.sharedInstance().saveContext()
            self.pushBoardViewController(board)
        }
        userInput("Enter the new board's title", handler: handler)
    }
    
    func pushBoardViewController(board: Board) {
        let ctrl = storyboard!.instantiateViewControllerWithIdentifier("BoardViewController") as! BoardViewController
        ctrl.board = board
        navigationController!.pushViewController(ctrl, animated: true)
    }
    
    // Helper: Core Data
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Board")
        
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest, managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    } ()
    
    // UITableViewController
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let board = fetchedResultsController.objectAtIndexPath(indexPath) as! Board
        let cell = tableView.dequeueReusableCellWithIdentifier("BoardCell")!
        cell.textLabel?.text = board.title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let board = fetchedResultsController.objectAtIndexPath(indexPath) as! Board
        pushBoardViewController(board)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (editingStyle) {
        case .Delete:
            let board = fetchedResultsController.objectAtIndexPath(indexPath) as! Board
            sharedContext.deleteObject(board)
            CoreDataStackManager.sharedInstance().saveContext()
            
        default:
            break
        }
    }
    
    // NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
            
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!)!
            let board = controller.objectAtIndexPath(indexPath!) as! Board
            cell.textLabel?.text = board.title
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}

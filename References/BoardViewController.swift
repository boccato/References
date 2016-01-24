//
//  BoardViewController.swift
//  References
//
//  Created by Ricardo Boccato Alves on 1/22/16.
//  Copyright © 2016 Ricardo Boccato Alves. All rights reserved.
//

import CoreData
import UIKit

class BoardViewController: UIViewController {
    
    var board: Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let board = board {
            title = board.title
        }
//        else {
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "newBoard")
//        }
    }
    
//    func newBoard() {
//        guard let title = txtTitle.text else {
//            showAlert("Warning", message: "The board needs a title.")
//            return
//        }
//        guard title != "" else {
//            showAlert("Warning", message: "The board needs a title.")
//            return
//        }
//        board = Board(title: title, context: sharedContext)
//        navigationController?.popViewControllerAnimated(true)
//    }
    
}

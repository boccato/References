//
//  PageItemViewController.swift
//  References
//
//  Created by Ricardo Boccato Alves on 1/24/16.
//  Copyright © 2016 Ricardo Boccato Alves. All rights reserved.
//

import UIKit

class PageItemViewController: UIViewController {
    
    var itemIndex: Int = 0
    var path: String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = path {
            imageView!.image = UIImage(named: path)
        }
    }
}

//
//  AddPhotosViewController.swift
//  References
//
//  Created by Ricardo Boccato Alves on 1/24/16.
//  Copyright © 2016 Ricardo Boccato Alves. All rights reserved.
//

import CoreData
import UIKit

class AddPhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var photos = [Photo]()
    private var selected = [Bool]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var board: Board?
    
    // UIViewController
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Lay out the collection view so that cells take up 1/3 of the width.
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let width = floor((self.collectionView.frame.size.width-8)/3)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
    }
    
    // Buttons
    
    @IBAction func done(sender: UIButton) {
        var needSaving = false
        for i in photos.indices {
            if selected[i] {
                let photo = photos[i]
                photo.saveImage()
                let _ = File(id: photo.id, board: self.board!, context: CoreDataStackManager.sharedInstance().managedObjectContext)
                needSaving = true
            }
        }
        if needSaving {
            CoreDataStackManager.sharedInstance().saveContext()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func search(sender: UIButton) {
        dismissAnyVisibleKeyboards()
        
        photos = [Photo]()
        collectionView.reloadData()
        searchButton.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        FlickrClient.sharedInstance().searchPhotosBy(searchTextField!.text!) { (album, error) in
            guard error == "" else {
                self.showAlert("Error", message: "Could not load images from Flickr.")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.searchButton.hidden = false
                return
            }
            for photo in album {
                self.photos.append(Photo(dictionary: photo))
                self.selected.append(false)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.searchButton.hidden = false
                self.collectionView.reloadData()
            }
        }
    }
    
    // UICollectionViewDataSource, UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        let photo = photos[indexPath.item]
        (cell as! UIPhotoCell).photo = photo
        configureCell(cell as! UIPhotoCell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! UIPhotoCell

        // Whenever a cell is tapped we will toggle its presence in the selectedIndexes array.
        selected[indexPath.item] = !selected[indexPath.item]

        // Then reconfigure the cell.
        configureCell(cell, atIndexPath: indexPath)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Helper methods
    
    private func configureCell(cell: UIPhotoCell, atIndexPath indexPath: NSIndexPath) {

        // If the cell is "selected" it's color panel is grayed out.
        if selected[indexPath.item] {
            cell.backgroundView?.alpha = 0.5
        } else {
            cell.backgroundView?.alpha = 1.0
        }
    }
    
    func dismissAnyVisibleKeyboards() {
        if searchTextField.isFirstResponder() {
            self.view.endEditing(true)
        }
    }
}

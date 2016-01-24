//
//  AddPhotosViewController.swift
//  References
//
//  Created by Ricardo Boccato Alves on 1/24/16.
//  Copyright © 2016 Ricardo Boccato Alves. All rights reserved.
//

import UIKit

class AddPhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var images = [UIImage]()
    private var photos = [Photo]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
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
    
    @IBAction func search(sender: UIButton) {
        photos = [Photo]()
        collectionView.reloadData()
        FlickrClient.sharedInstance().searchPhotosBy(searchTextField!.text!) { (album, error) in
            guard error == "" else {
                return
            }
            for photo in album {
                self.photos.append(Photo(dictionary: photo))
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }
    }
    
    // UICollectionViewDataSource, UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
        let photo = photos[indexPath.item]
        (cell as! UIPhotoCell).photo = photo
//        configureCell(cell as! UIPhotoCell, atIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! UIPhotoCell
//        
//        // Whenever a cell is tapped we will toggle its presence in the selectedIndexes array
//        if let index = selectedIndexes.indexOf(indexPath) {
//            selectedIndexes.removeAtIndex(index)
//        } else {
//            selectedIndexes.append(indexPath)
//        }
//        
//        // Then reconfigure the cell
//        configureCell(cell, atIndexPath: indexPath)
//        
//        // And update the buttom button
//        updateBottomButton()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
}

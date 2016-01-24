//
//  BoardViewController.swift
//  References
//
//  Created by Ricardo Boccato Alves on 1/24/16.
//  Copyright © 2016 Ricardo Boccato Alves. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    private var pageViewController: UIPageViewController?
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    var board: Board?
    
    override func viewDidLoad() {
        if let board = board {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPhotos")
            title = board.title

            createPageViewController()
            setupPageControl()
        }
    }
    
    func addPhotos() {
        let ctrl = storyboard!.instantiateViewControllerWithIdentifier("AddPhotosViewController") as! AddPhotosViewController
        presentViewController(ctrl, animated: true, completion: nil)
    }
    
    private func createPageViewController() {
        
        let ctrl = storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        contentImageView.image = UIImage(named: "not-found")
//        pageController.dataSource = self
//        
//        if contentImages.count > 0 {
//            let firstController = getItemController(0)!
//            let startingViewControllers: NSArray = [firstController]
//            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
//        }
//
        pageViewController = ctrl
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    

//    
//    // UICollectionViewController
//    
//    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)
//        cell.backgroundView = UIImageView(image: UIImage(named: "not-found"))
////        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
////        (cell as! UIPhotoCell).photo = photo
////        configureCell(cell as! UIPhotoCell, atIndexPath: indexPath)
//        return cell
//    }
    
}
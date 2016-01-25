//
//  BoardViewController.swift
//  References
//
//  Created by Ricardo Boccato Alves on 1/24/16.
//  Copyright © 2016 Ricardo Boccato Alves. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, UIPageViewControllerDataSource {
    
    private var pageViewController: UIPageViewController?
    
    var board: Board?
    
    // UIViewController
    
    override func viewDidLoad() {
        if let board = board {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPhotos")
            title = board.title

            createPageViewController()
            setupPageControl()
        }
    }
    
    // Buttons
    
    func addPhotos() {
        let ctrl = storyboard!.instantiateViewControllerWithIdentifier("AddPhotosViewController") as! AddPhotosViewController
        ctrl.board = board
        presentViewController(ctrl, animated: true, completion: nil)
        createPageViewController()
    }
    
    // Helper methods
    
    private func createPageViewController() {
        let ctrl = storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        ctrl.dataSource = self
        
        if board!.files.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: [UIViewController] = [firstController]
            ctrl.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        }
        
        pageViewController = ctrl
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }

    private func getItemController(itemIndex: Int) -> PageItemViewController? {
        
        if itemIndex < board!.files.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("PageItemViewController") as! PageItemViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.path = board!.filesAsArray()[itemIndex].createPathWithId()
            return pageItemController
        }
        
        return nil
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    // UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemViewController
        
        if itemController.itemIndex+1 < board!.files.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return board!.files.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

//
//  Photo.swift
//  References
//
//  Created by Ricardo Boccato Alves on 11/21/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import UIKit

class Photo {
    
    struct Keys {
        static let Id = "Id"
        static let URL = "URL"
    }
    
    var id: String
    var url: String
    
    private lazy var group: dispatch_group_t = { return dispatch_group_create() }()
    private var image: UIImage?
    
    init(dictionary: [String : AnyObject]) {
        id = dictionary[Keys.Id] as! String
        url = dictionary[Keys.URL] as! String
        
        // Download image.
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            if let
                url = NSURL(string: self.url),
                data = NSData(contentsOfURL: url),
                image = UIImage(data: data)
            {
                self.image = image
            }
            else {
                self.image = UIImage(named: "not-found")
            }
        }
    }
    
    private func createPathWithId() -> String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent(id).path!
    }
    
    func saveImage() -> String? {
        if let image = self.image {
            if let data = UIImageJPEGRepresentation(image, 1.0) {
                let path = createPathWithId()
                data.writeToFile(path, atomically: true)
                return path
            }
        }
        return nil
    }
    
    func withLoadedImage(completionHandler: (image: UIImage?) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            dispatch_group_wait(self.group, DISPATCH_TIME_FOREVER)
            completionHandler(image: self.image)
        }
    }
}

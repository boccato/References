//
//  Util.swift
//  References
//
//  Created by Ricardo Boccato Alves on 10/24/15.
//  Copyright © 2015 Ricardo Boccato Alves. All rights reserved.
//

import CoreData
import Foundation
import UIKit

extension UIViewController {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(CGPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.addAnimation(animation, forKey: "position")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func userInput(title: String, handler: ((String) -> Void)?) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(_) in
            if let handler = handler {
                handler(alert.textFields![0].text!)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: {(_) in
            if let handler = handler {
                handler("")
            }
        }))
        
        alert.addTextFieldWithConfigurationHandler({(textField) in
            textField.placeholder = title
        })
        
        presentViewController(alert, animated: true, completion: nil)
    }
}

/*
    var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
    alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
        textField.placeholder = "Enter text:"
        textField.secureTextEntry = true
    })
    self.presentViewController(alert, animated: true, completion: nil)
*/
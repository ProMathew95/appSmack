//
//  AlertView.swift
//  Flash Chat
//
//
//

import Foundation
import UIKit

class AlertView
{
  
    
    static func show(aTitle:String,aMessage:String) ->UIAlertController
    {
       let myalert = UIAlertController.init(title:aTitle, message: aMessage, preferredStyle:.alert)
       myalert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        return myalert
        
    }
    
    
    
}

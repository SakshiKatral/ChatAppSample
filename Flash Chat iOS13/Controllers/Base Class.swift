//
//  Base Class.swift
//  Flash Chat iOS13
//
//  Created by Mac on 12/08/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation
import UIKit
class BaseClass: UIViewController{
    func alertController(with error: String){
        let alert = UIAlertController(title: "Oops!",
                                      message: error,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Close",
                                         style: .default,
                                         handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    var  baseClass = BaseClass()
    @IBAction func registerPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                self.baseClass.alertController(with: error.localizedDescription)
            }
            else{
                self.performSegue(withIdentifier: Constances.registerSegue, sender: self)
            }
        }
    }
    
}

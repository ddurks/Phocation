//
//  SignUpViewController.swift
//  Phocation
//
//  Created by David Durkin on 4/17/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var username: String?
    var password: String?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onUsernameUpdate(_ sender: Any) {
        self.username = usernameField.text
    }
    
    @IBAction func onPasswordUpdate(_ sender: Any) {
        self.password = passwordField.text
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let user = PFUser()
        user.username = self.username
        user.password = self.password
        user.signUpInBackground {
            (success, error) -> Void in
            if let error = error as NSError? {
                _ = error.userInfo["error"] as? NSString
                // In case something went wrong, use errorString to get the error
                let alert = UIAlertController(title: "Invalid Username", message: "Username in use, Please Enter a different one", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
            } else {
                // Everything went okay
                currentUser.userName = self.username
                currentUser.password = self.password
                let defaults = UserDefaults.standard
                defaults.set(currentUser.userName, forKey: "User")
                defaults.set(currentUser.password, forKey: "Pass")
                defaults.synchronize()
            }
        }
    }
    
    override func viewDidLoad() {
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.usernameField.text = currentUser.userName
        self.passwordField.text = currentUser.password
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  LogInViewController.swift
//  Phocation
//
//  Created by David Durkin on 4/17/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
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
    
    @IBAction func logInPressed(_ sender: Any) {
        if self.username != nil && self.password != nil {
            
            PFUser.logInWithUsername(inBackground: self.username!, password: self.password!) {
                (objects, error) -> Void in
                if error == nil {
                    let currUser = PFUser.current()
                    currentUser.userName = self.username
                    currentUser.password = self.password
                    print("\(currUser?.username!) logged in successfully")
                    let defaults = UserDefaults.standard
                    defaults.set(currentUser.userName, forKey: "User")
                    defaults.set(currentUser.password, forKey: "Pass")
                    defaults.synchronize()
                }
                else{
                    print("Not logged in")
                }
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


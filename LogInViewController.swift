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
    var uSet = false
    var pSet = false
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onUsernameEdit(_ sender: Any) {
        self.signInButton.isEnabled = false
    }
    @IBAction func onUsernameUpdate(_ sender: Any) {
        self.username = usernameField.text!
        self.uSet = true
        self.signInButton.isEnabled = true
    }
    
    
    @IBAction func onPasswordEdit(_ sender: Any) {
        self.signInButton.isEnabled = false
    }
    @IBAction func onPasswordUpdate(_ sender: Any) {
        self.password = passwordField.text!
        self.pSet = true
        self.signInButton.isEnabled = true
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        print("Loggin in")

        if uSet == true && pSet == true {
            signInButton.isEnabled = false
            PFUser.logInWithUsername(inBackground: self.username!,password: self.password!) {
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
                    let message = "Username: " + currentUser.userName!
                    let alert = UIAlertController(title: "Logged in", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    print("Not logged in")
                    let alert = UIAlertController(title: "Error logging in", message: "Username or password invalid", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Try Again", style: .cancel)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }

            }
            signInButton.isEnabled = true
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


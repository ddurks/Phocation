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
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var username = ""
    var password = ""
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onUsernameEdit(_ sender: Any) {
        self.signUpButton.isEnabled = false
    }
    @IBAction func onUsernameUpdate(_ sender: Any) {
        self.username = usernameField.text!
        self.signUpButton.isEnabled = true
    }
    
    @IBAction func onPasswordEdit(_ sender: Any) {
        self.signUpButton.isEnabled = false
    }
    @IBAction func onPasswordUpdate(_ sender: Any) {
        self.password = passwordField.text!
        self.signUpButton.isEnabled = true
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
                    let okAction = UIAlertAction(title: "Try Again", style: .cancel)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // Everything went okay
                    currentUser.userName = self.username
                    currentUser.password = self.password
                    let defaults = UserDefaults.standard
                    defaults.set(currentUser.userName, forKey: "User")
                    defaults.set(currentUser.password, forKey: "Pass")
                    defaults.synchronize()
                    let message = "Username: " + currentUser.userName!
                    let alert = UIAlertController(title: "Signed up", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }
    
    override func viewDidLoad() {
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.navigationItem.title = "SIGN UP"    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

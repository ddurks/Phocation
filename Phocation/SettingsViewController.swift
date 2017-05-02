//
//  SettingsViewController.swift
//  Phocation
//
//  Created by David Durkin on 2/13/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import UIKit
import Parse
import Bolts

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var currUser: UILabel!
    
    @IBOutlet weak var lifeSpan: UILabel!
    
    @IBOutlet weak var lifeSpanSlider: UISlider!
    
    @IBOutlet weak var zeroHours: UILabel!
    
    @IBOutlet weak var twoFourHours: UILabel!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SETTINGS"
        // Do any additional setup after loading the view.
        let currentValue = Int(lifeSpanSlider.value)
        lifeSpan.text = "Posted Photo Lifespan: \(currentValue) hours"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currUser.text = "Username: " + currentUser.userName!
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onSlide(_ sender: Any) {
        let currentValue = Int(lifeSpanSlider.value)
        lifeSpan.text = "Posted Photo Lifespan: \(currentValue) hours"
    }
    @IBAction func onUserNameUpdate(_ sender: Any) {
        /*let defaults = UserDefaults.standard
        defaults.set(userName.text, forKey: "User")
        defaults.synchronize()
        
        // Defining the user object
        let user = PFUser()
        user.username = userName.text
        user.password = "Test"
        
        // Signing up using the Parse API
        user.signUpInBackground {
            (success, error) -> Void in
            if let error = error as NSError? {
                _ = error.userInfo["error"] as? NSString
                // In case something went wrong, use errorString to get the error
                _ = UIAlertController(title: "Invalid Username", message: "Please Enter a Different One", preferredStyle: UIAlertControllerStyle.alert)
            } else {
                // Everything went okay
            }
        }*/
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
    
    @IBOutlet weak var settingsBackButton: UIButton!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var localGlobalSwitch: UISwitch!
    
    @IBOutlet weak var local: UILabel!
    
    @IBOutlet weak var global: UILabel!
    
    @IBOutlet weak var photoVisLabel: UILabel!
    
    @IBOutlet weak var lifeSpan: UILabel!
    
    @IBOutlet weak var lifeSpanSlider: UISlider!
    
    @IBOutlet weak var zeroHours: UILabel!
    
    @IBOutlet weak var twoFourHours: UILabel!
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.delegate = self
        // Do any additional setup after loading the view.
        userName.text = currentUser.userName
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onUserNameUpdate(_ sender: Any) {
        let defaults = UserDefaults.standard
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
        }
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

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // set up values based on current user's settings
        currUser.text = "Username: " + currentUser.userName!
        self.lifeSpanSlider.value = Float(currentUser.lifespan!)
        let currentValue = Int(lifeSpanSlider.value)
        lifeSpan.text = "Posted Photo Lifespan: \(currentValue) hours"    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onSlide(_ sender: Any) {
        // update lifespan values based on slide and save to defaults for persistence
        let currentValue = Int(lifeSpanSlider.value)
        lifeSpan.text = "Posted Photo Lifespan: \(currentValue) hours"
        currentUser.lifespan = currentValue
        let defaults = UserDefaults.standard
        defaults.set(currentValue, forKey: "Lifespan")
        defaults.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

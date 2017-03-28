//
//  SettingsViewController.swift
//  Phocation
//
//  Created by David Durkin on 2/13/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
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

        // Do any additional setup after loading the view.
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

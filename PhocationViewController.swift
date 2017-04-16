//
//  PhocationViewController.swift
//  Phocation
//
//  Created by David Durkin on 4/15/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class PhocationViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var imageViewer: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var unlikeButton: UIButton!
    
    @IBOutlet weak var userName: UILabel!
    
    var id:String?
    
    var likes = 0
    
    override func viewDidLoad() {
        print("\(self.id)")
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: self.id!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                self.userName.text = object?["userName"] as? String
                let thumbnail = object?["imageFile"] as! PFFile
                print("\(thumbnail)")
                thumbnail.getDataInBackground{(imageData: Data?, error: Error?) -> Void in
                    if error == nil {
                        if let image = UIImage(data: imageData!) {
                            self.imageViewer.contentMode = .scaleAspectFit
                            self.imageViewer.image = image
                        }
                    }
                }
                print("retrieved image")
            } else {
                print("error")
            }
        }
        //imageViewer.contentMode = .scaleAspectFit
        //imageViewer.image = currentUser.currImage
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

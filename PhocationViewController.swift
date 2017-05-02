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
    
    @IBOutlet weak var imageViewer: UIImageView!
    
    @IBOutlet weak var numLikes: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var id:String?
    
    var image: UIImage?
    
    // pull new like value server when liked
    var liked:Bool? {
        didSet {
            getLikes(change: 0)
        }
    }
    
    // set like text when updated
    var likenum: Int! {
        didSet {
            self.numLikes.text = String(self.likenum)
        }
    }
    
    override func viewDidLoad() {
        // set up nav bar and swipe handlers
        self.deleteButton.isHidden = true

        let barLikes = UIBarButtonItem(customView: self.numLikes)
        self.navigationItem.rightBarButtonItem = barLikes
        
        self.isLiked()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        // retrieve post image and display in imageView
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: self.id!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                let user = object?["userName"] as? String
                self.navigationItem.title = user
                if(user == currentUser.userName){
                    self.deleteButton.isHidden = false
                }
                let thumbnail = object?["imageFile"] as! PFFile
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // handle swipes for likes and unlikes
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.down:
                if self.liked == true {
                    print("Unlike")
                    self.removeLike()
                    self.liked = false
                }
                else {
                    //print("Can't unlike")
                }
            case UISwipeGestureRecognizerDirection.up:
                if self.liked == false {
                    print("Like")
                    self.addLike()
                    self.liked = true
                }
                else {
                    //print("Can't Like")
                }
            default:
                break
            }
        }
    }
    
    // retrieve likes from post
    func getLikes(change: Int) {
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: self.id!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                var likes = object?["likes"] as! Int
                likes = likes + change
                object?["likes"] = likes
                object?.saveInBackground()
                
                self.likenum = likes
            } else {
                print("\(error)")
                return
            }
        }
    }
    
    // add a like to a post from a certain user
    func addLike() {
        let like = Like()
        like.fromUser = currentUser.userName
        like.toPost = self.id
        like.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                self.getLikes(change: 1)
            } else {
                print("\(error)")
                // There was a problem, check error.description
            }
        }
    }
    
    // remove a like from a post from a certain user
    func removeLike() {
        let query = PFQuery(className: "Like")
        query.whereKey("fromUser", equalTo: currentUser.userName! as String)
        query.whereKey("toPost", equalTo: self.id!)
        query.findObjectsInBackground {
            (objects, error) -> Void in
            if error == nil {
                for object in objects!{
                    object.deleteEventually()
                }
                self.getLikes(change: -1)
            } else{
                print("\(error)")
            }
        }
    }
    
    // check if phocation has already been liked by a user, disable liking if so
    func isLiked() {
        let query = PFQuery(className: "Like")
        query.whereKey("fromUser", equalTo: currentUser.userName! as String)
        query.whereKey("toPost", equalTo: self.id!)
        query.findObjectsInBackground {
            (objects, error) -> Void in
            if error == nil {
                    if (objects?.isEmpty)! {
                        self.liked = false
                        //print("haven't liked yet")
                    }
                    else{
                        self.liked = true
                        //print("have liked it")
                    }
            } else{
                print("\(error)")
            }
        }
    }
    
    // Function for deleting post should owner so choose
    @IBAction func deletePost(_ sender: Any) {
        let alert = UIAlertController(title: "Delete?", message: "Are You Sure You Want to Delete This Post?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.delete()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // function that actually deletes post if user opts to
    func delete(){
        self.deleteButton.isEnabled = false
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: self.id!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                //print("deleting")
                object?["alive"] = 0
                object?.saveInBackground()
                super.performSegue(withIdentifier: "deleteSegue", sender: self.deleteButton)
            } else {
                print("\(error)")
            }
        }
    }
    
}

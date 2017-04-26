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
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var unlikeButton: UIButton!
    
    @IBOutlet weak var numLikes: UILabel!
    
    var likeImage = UIImage(named: "phocationHeart.png")
    
    var unlikeImage = UIImage(named: "phocationBrokenHeart.png")
    
    var id:String?
    
    var image: UIImage?
    
    var liked:Bool? {
        didSet {
            self.likeButton.isEnabled = !self.liked!
            self.unlikeButton.isEnabled = self.liked!
            getLikes(change: 0)
        }
    }
    
    var likes: Int! {
        didSet {
            self.numLikes.text = String(self.likes)
        }
    }
    
    override func viewDidLoad() {
        //self.likeButton.setImage(likeImage, for: UIControlState.normal )
        //self.unlikeButton.setImage(unlikeImage, for: UIControlState.normal)
        self.numLikes.backgroundColor = UIColor(patternImage: UIImage(named: "phocationHeart.png")!)
        let barLikes = UIBarButtonItem(customView: self.numLikes)
        self.navigationItem.rightBarButtonItem = barLikes
        self.likeButton.isEnabled = false
        self.unlikeButton.isEnabled = false
        self.isLiked()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: self.id!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                self.navigationItem.title = object?["userName"] as? String
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
        //imageViewer.contentMode = .scaleAspectFit
        //imageViewer.image = currentUser.currImage
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.down:
                if self.liked == false {
                    self.getLikes(change: -1)
                    self.removeLike()
                    self.liked = true
                }
            case UISwipeGestureRecognizerDirection.up:
                if self.liked == true {
                    self.getLikes(change: 1)
                    self.addLike()
                    self.liked = false
                }
            default:
                break
            }
        }
    }
    
    func getLikes(change: Int) {
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: self.id!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                var likes = object?["likes"] as! Int
                likes = likes + change
                object?["likes"] = likes
                object?.saveInBackground()
                
                self.likes = likes
            } else {
                print("\(error)")
                return
            }
        }
    }
    
    func addLike() {
        let like = Like()
        like.fromuser = currentUser.userName
        like.topost = self.id
        like.upload()
    }
    
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
            } else{
                print("\(error)")
            }
        }
    }
    
    func isLiked() {
        let query = PFQuery(className: "Like")
        query.whereKey("fromUser", equalTo: currentUser.userName! as String)
        query.whereKey("toPost", equalTo: self.id!)
        query.findObjectsInBackground {
            (objects, error) -> Void in
            if error == nil {
                    if (objects?.isEmpty)! {
                        self.liked = false
                        print("empty")
                    }
                    else{
                        self.liked = true
                        print("found")
                    }
            } else{
                print("\(error)")
            }
        }
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        self.unlikeButton.isEnabled = true
        self.getLikes(change: 1)
        self.addLike()
        self.likeButton.isEnabled = false
    }
    
    @IBAction func unlikeTapped(_ sender: Any) {
        self.likeButton.isEnabled = true
        self.getLikes(change: -1)
        self.removeLike()
        self.unlikeButton.isEnabled = false
    }
    
}

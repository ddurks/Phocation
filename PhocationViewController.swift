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
    
    @IBOutlet weak var numLikes: UILabel!
    
    var id:String?
    
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
        self.likeButton.isEnabled = false
        self.unlikeButton.isEnabled = false
        self.isLiked()
        let query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: self.id!) {
            (object: PFObject?, error: Error?) -> Void in
            if error == nil && object != nil {
                self.userName.text = object?["userName"] as? String
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
        query.findObjectsInBackground {
            (objects, error) -> Void in
            if error == nil {
                    if (objects?.isEmpty)! {
                        self.liked = false
                    }
                    else{
                        self.liked = true
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

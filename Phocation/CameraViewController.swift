//
//  CameraViewController.swift
//  Phocation
//
//  Created by David Durkin on 2/12/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imageViewer: UIImageView!
    
    @IBOutlet weak var takeButton: UIButton!
    
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var image = UIImage()
    
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NEW PHOCATION"
        imagePicker.delegate = self
        postButton.isEnabled = false
        let barButton = UIBarButtonItem(customView: self.postButton)
        self.navigationItem.rightBarButtonItem = barButton

    }
    
    // post a photo to server
    @IBAction func postPhoto(_ sender: Any) {
        postButton.isEnabled = false
        PhotoTakingHelper(image: self.image)
        postButton.isEnabled = true
    }
    
    //take a new photo from camera
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //choose a new photo from camera roll
    @IBAction func choosePhoto(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // controller for camera access
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        postButton.isEnabled = true
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            self.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        } else if mediaType.isEqual(to: kUTTypeMovie as String) {
            self.image = info[UIImagePickerControllerMediaURL] as! UIImage
        }
  
        imageViewer.contentMode = .scaleAspectFit
        imageViewer.image = self.image
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    // helper function for posting photos with all info to server
    func PhotoTakingHelper(image: UIImage?) {
        if let image = image {
            let post = Post()
            post.image = image
            post.latitude = currentUser.latitude
            post.longitude = currentUser.longitude
            post.location = PFGeoPoint(latitude: Double(currentUser.latitude!)!, longitude: Double(currentUser.longitude!)!)
            post.username = PFUser.current()?.username
            post.likenum = 0
            post.life = currentUser.lifespan
            post.live = 1
            post.upload()
            post.saveInBackground {
                (success: Bool, error: Error?) -> Void in
                if (success) {
                    // The object has been saved.
                    let alert = UIAlertController(title: "Posted", message: "Phocation has been posted", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("error")
                    // There was a problem, check error.description
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

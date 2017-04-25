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
    
    @IBAction func postPhoto(_ sender: Any) {
        postButton.isEnabled = false
        PhotoTakingHelper(image: self.image)
        postButton.isEnabled = true
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
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

    func PhotoTakingHelper(image: UIImage?) {
        if let image = image {
            let post = Post()
            post.image = image
            post.latitude = currentUser.latitude
            post.longitude = currentUser.longitude
            post.location = PFGeoPoint(latitude: Double(currentUser.latitude!)!, longitude: Double(currentUser.longitude!)!)
            post.username = PFUser.current()?.username
            post.likenum = 0
            post.life = 24
            post.upload()
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

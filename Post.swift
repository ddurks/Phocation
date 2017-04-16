//
//  Post.swift
//  Phocation
//
//  Created by David Durkin on 3/29/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import Parse

// 1
class Post : PFObject, PFSubclassing {
    
    // 2
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    @NSManaged var userName: String?
    @NSManaged var userLat: String?
    @NSManaged var userLong: String?
    @NSManaged var userLocation: PFGeoPoint?
    
    var image: UIImage?
    var latitude: String?
    var longitude: String?
    var location: PFGeoPoint?
    var username: String?
    
    func upload(){
        if self.image != nil  {
            // 1
            let imageData = UIImageJPEGRepresentation(self.image!, 0.8)!
            let imageFile = PFFile(data: imageData)
            imageFile?.saveInBackground()
            // 2
            self.imageFile = imageFile
            self.user = PFUser.current()
            self.userLat = self.latitude
            self.userLong = self.longitude
            self.userLocation = self.location
            self.userName = self.username
            self.saveInBackground {
                (success: Bool, error: Error?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
        }
    }
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Post"
    }
    
    // 4
    override init () {
        super.init()
    }
    
}

//
//  Post.swift
//  Phocation
//
//  Created by David Durkin on 3/29/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import Parse

// custom class to define posts created by users to be uploaded to the server
class Post : PFObject, PFSubclassing {
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    @NSManaged var userName: String?
    @NSManaged var userLat: String?
    @NSManaged var userLong: String?
    @NSManaged var userLocation: PFGeoPoint?
    @NSManaged var likes: NSNumber?
    @NSManaged var lifespan: NSNumber?
    @NSManaged var alive: NSNumber?
    
    var image: UIImage?
    var latitude: String?
    var longitude: String?
    var location: PFGeoPoint?
    var username: String?
    var likenum: Int?
    var life: Int?
    var live: Int?
    
    func upload(){
        if self.image != nil  {
            let imageData = UIImageJPEGRepresentation(self.image!, 0.8)!
            let imageFile = PFFile(data: imageData)
            imageFile?.saveInBackground()

            self.imageFile = imageFile
            self.user = PFUser.current()
            self.userLat = self.latitude
            self.userLong = self.longitude
            self.userLocation = self.location
            self.userName = self.username
            self.likes = self.likenum as NSNumber?
            self.lifespan = self.life as NSNumber?
            self.alive = self.live as NSNumber?
        }
    }
    //MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init () {
        super.init()
    }
    
}

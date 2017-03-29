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
    
    var image: UIImage?
    
    func upload(){
        if let image = image {
            // 1
            let imageData = UIImageJPEGRepresentation(image, 0.8)!
            let imageFile = PFFile(data: imageData)
            imageFile?.saveInBackground()
            // 2
            self.imageFile = imageFile
            user = PFUser.current()
            saveInBackground()
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

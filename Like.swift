//
//  Like.swift
//  Phocation
//
//  Created by David Durkin on 4/17/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import Parse

class Like: PFObject, PFSubclassing {
    
    @NSManaged var toPost: String?
    @NSManaged var fromUser: String?
    
    var topost: String?
    var fromuser: String?
    
    func upload(){
        self.toPost = self.topost
        self.fromUser = self.fromuser
        self.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                print("error")
                // There was a problem, check error.description
            }
        }
    }
    
    static func parseClassName() -> String {
        return "Like"
    }
    
    // 4
    override init () {
        super.init()
    }
}

//
//  UserInfo.swift
//  Phocation
//
//  Created by David Durkin on 3/29/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import UIKit

class UserInfo {
    
    static let sharedUserInfo = UserInfo()
    
    var userName:String?
    var password:String?
    var latitude:String?
    var longitude:String?
    var lifespan:Int?
    
    init(){

    }
    
}

//
//  UserInfo.swift
//  Phocation
//
//  Created by David Durkin on 3/29/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation

class UserInfo {
    
    static let sharedUserInfo = UserInfo()
    
    var userName:String?
    var password:String?
    var location:String?
    
    init(){
        userName = "Anon"
        password = "test"
    }
    
}

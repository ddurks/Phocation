//
//  Phocation.swift
//  Phocation
//
//  Created by David Durkin on 4/15/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import MapKit

class Phocation: MKPointAnnotation {
    var id: String?
    var user: String?
    
    init(id: String, user: String, coordinate: CLLocationCoordinate2D) {
        super.init()
        self.title = id
        self.id = id
        self.user = user
        self.coordinate = coordinate
    }
}

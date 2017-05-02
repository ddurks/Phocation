//
//  Phocation.swift
//  Phocation
//
//  Created by David Durkin on 4/15/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import MapKit

// class to denote phocation annotations on the map
class Phocation: MKPointAnnotation {
    var id: String?
    var user: String?
    var image: UIImage?
    
    init(id: String, user: String, coordinate: CLLocationCoordinate2D, image: UIImage) {
        super.init()
        self.title = user
        self.subtitle = id
        self.id = id
        self.user = user
        self.coordinate = coordinate
        self.image = image
    }
}

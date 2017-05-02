//
//  MyPhocationsViewController.swift
//  Phocation
//
//  Created by David Durkin on 4/19/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts
import MapKit
import CoreLocation

class MyPhocationsViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var posts = NSMutableArray()
    
    var drawer = PhocationAnnotationView()
    
    var sendID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //mapView.showsUserLocation = true
        
        print("\(currentUser.userName)")
        let phocations = PFQuery(className: "Post")
        phocations.whereKey("userName", equalTo: currentUser.userName! as String)
        phocations.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) posts.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        //self.posts.add(object["userLocation"])
                        let lat = object["userLat"] as! String
                        let long = object["userLong"] as! String
                        let id = object.objectId as String!
                        let user = object["userName"] as! String
                        let user_id = user + ":" + id!
                        print("\(user_id)")
                        let longD = Double(long), latD = Double(lat)
                        print("\(lat) \(long) \(id)")
                        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latD!, longD!)
                        let thumbnail = object["imageFile"] as! PFFile
                        thumbnail.getDataInBackground{(imageData: Data?, error: Error?) -> Void in
                            if error == nil {
                                if let image = UIImage(data: imageData!) {
                                    let phImage = image
                                    let objectAnnotation = Phocation(id: id!, user: user, coordinate: pinLocation, image: phImage)
                                    self.mapView.addAnnotation(objectAnnotation)                                }
                            }
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) ")
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last
        
        currentUser.latitude = String(format: "%f", (location?.coordinate.latitude)!)
        currentUser.longitude = String(format: "%f", (location?.coordinate.longitude)!)
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error!: " + error.localizedDescription)
    }
}

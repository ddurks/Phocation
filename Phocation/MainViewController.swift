//
//  MainViewController.swift
//  Phocation
//
//  Created by David Durkin on 2/12/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import UIKit
import MapKit
import Parse
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var phocationsButton: UIButton!
    
    @IBOutlet weak var newPhotoButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var posts = NSMutableArray()
    
    var drawer = PhocationAnnotationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true

        let phocations = PFQuery(className: "Post")
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
                        let objectAnnotation = Phocation(id: id!, user: user, coordinate: pinLocation)
                        self.mapView.addAnnotation(objectAnnotation)
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


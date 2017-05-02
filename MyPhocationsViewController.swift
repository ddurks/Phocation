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
        
        // location manager set up
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //mapView.showsUserLocation = true
        
        print("\(currentUser.userName)")
        
    }
    
    // function for computing date interval in hours
    func interval(date1: Date, date2: Date) -> Int {
        let date1str = String(describing: date1)
        let date2str = String(describing: date2)
        let date1A = date1str.components(separatedBy: " ")
        let date2A = date2str.components(separatedBy: " ")
        if(date1A[0] == date2A[0]){
            let time1 = date1A[1].components(separatedBy: ":")
            let time2 = date2A[1].components(separatedBy: ":")
            let diff = Int(time2[0])! - Int(time1[0])!
            return diff
        }
        else {
            return 24
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // load posts only if they belong to logged in user and are alive
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
                        //let user_id = user + ":" + id!
                        //print("\(user_id)")
                        let longD = Double(long), latD = Double(lat)
                        //print("\(lat) \(long) \(id)")
                        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latD!, longD!)
                        var alive = object["alive"] as! Int
                        let lifespan = object["lifespan"] as! Int
                        let postDate = object.createdAt! as Date
                        let currDate = Date()
                        let diff = self.interval(date1: postDate, date2: currDate)
                        if (diff >= lifespan) {
                            alive = 0
                            object["alive"] = 0
                            object.saveInBackground()
                        }
                        let thumbnail = object["imageFile"] as! PFFile
                        thumbnail.getDataInBackground{(imageData: Data?, error: Error?) -> Void in
                            if error == nil {
                                if let image = UIImage(data: imageData!) {
                                    let phImage = image
                                    let objectAnnotation = Phocation(id: id!, user: user, coordinate: pinLocation, image: phImage)
                                    if(alive == 1) {
                                        self.mapView.addAnnotation(objectAnnotation)
                                    }
                                    else {
                                        self.mapView.removeAnnotation(objectAnnotation)
                                    }
                                }
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
    
    // location manager helper for user location
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

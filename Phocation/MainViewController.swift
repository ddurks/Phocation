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

class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var phocationsButton: UIButton!
    
    @IBOutlet weak var newPhotoButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        /*
        let phocations = Post.query()
        
        for object in phocations {
            var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(Int(object.userLat), Int(object.userLong))
            var objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = "Post"
            self.mapView.addAnnotation(objectAnnotation)
            
        }
 */
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last

        currentUser.latitude = String(format: "%f", (location?.coordinate.latitude)!)
        currentUser.longitude = String(format: "%f", (location?.coordinate.longitude)!)
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error!: " + error.localizedDescription)
    }


}


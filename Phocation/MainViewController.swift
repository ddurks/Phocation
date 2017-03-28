//
//  MainViewController.swift
//  Phocation
//
//  Created by David Durkin on 2/12/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var newPhotoButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var phocationsButton: UIButton!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error!: " + error.localizedDescription)
    }


}


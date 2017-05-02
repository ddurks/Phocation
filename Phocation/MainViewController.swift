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

protocol HandleMapSearch {
    func zoomTo(placemark:MKPlacemark)
}

class MainViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var phocationsButton: UIButton!
    
    @IBOutlet weak var newPhotoButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var posts = NSMutableArray()
    
    var drawer = PhocationAnnotationView()
    
    var resultSearchController:UISearchController? = nil
    
    var sendID: String?
    
    var sendImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
        navigationController?.navigationBar.tintColor = UIColor.magenta
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.cyan]
        
        mapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        self.resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        self.resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
                        let longD = Double(long), latD = Double(lat)
                        let alive = object["alive"] as! Int
                        print("\(lat) \(long) \(id) \(object.createdAt) \(alive)")
                        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latD!, longD!)
                        let thumbnail = object["imageFile"] as! PFFile
                        thumbnail.getDataInBackground{(imageData: Data?, error: Error?) -> Void in
                            if error == nil {
                                if let image = UIImage(data: imageData!) {
                                    let objectAnnotation = Phocation(id: id!, user: user, coordinate: pinLocation, image: image)
                                    if (alive == 1) {
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

extension MainViewController: HandleMapSearch {

    func zoomTo(placemark:MKPlacemark){

        let coordinate = placemark.coordinate
        
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        
        self.mapView.setRegion(region, animated: true)
    }
    
}

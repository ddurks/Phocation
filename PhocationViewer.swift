//
//  PhocationViewer.swift
//  Phocation
//
//  Created by David Durkin on 4/15/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import Parse
import Bolts

extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is Phocation {
            let annotation = annotation as! Phocation
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.title!) { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKAnnotationView(annotation: annotation,reuseIdentifier: annotation.title)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            view.isEnabled = true
            
            // Resize image
            let pinImage = UIImage(named: "redCircle.png")
            let size = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            view.image = resizedImage
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            super.performSegue(withIdentifier: "phocationSegue", sender: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "phocationSegue"){        
            let phocationViewController = (segue.destination as! PhocationViewController)
            phocationViewController.id = (sender as! MKAnnotationView).annotation!.title!
        }
    }
}

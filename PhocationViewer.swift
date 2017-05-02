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

        if annotation is MKUserLocation {
            return nil
        }
        if annotation is Phocation {
            let annotation = annotation as! Phocation
            var view: PhocationAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.title!) { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView as! PhocationAnnotationView
            } else {
                // 3
                view = PhocationAnnotationView(annotation: annotation,reuseIdentifier: annotation.title)
            }
            view.isEnabled = true
            
            // Resize image
            let pinImage = UIImage(named: "annotationCircle.png")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "phocationSegue"){        
            let phocationViewController = (segue.destination as! PhocationViewController)
            phocationViewController.id = self.sendID
        }
    }
    
    func showPhocation(sender:UIButton){
        super.performSegue(withIdentifier: "phocationSegue", sender: view)
    }
    
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let phAnnotation = view.annotation as! Phocation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.phocationImage.contentMode = .scaleAspectFit
        calloutView.phocationImage.image = phAnnotation.image
        self.sendID = phAnnotation.id
        let button = UIButton(frame: calloutView.phocationImage.frame)
        button.addTarget(self, action: #selector(MainViewController.showPhocation(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: PhocationAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
}

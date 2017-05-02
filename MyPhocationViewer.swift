//
//  MyPhocationViewer.swift
//  Phocation
//
//  Created by David Durkin on 4/19/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import Parse
import Bolts

// extension class to assist with my phocations view controller
extension MyPhocationsViewController: MKMapViewDelegate {
    
    // set up custom phocation annotation views
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is Phocation {
            let annotation = annotation as! Phocation
            var view: PhocationAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.title!) { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView as! PhocationAnnotationView
            } else {
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
    
    // prepare for segue if phocation callout tapped
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "phocationSegue1"){
            let phocationViewController = (segue.destination as! PhocationViewController)
            phocationViewController.id = self.sendID
        }
    }
    
    func showPhocation(sender:UIButton){
        super.performSegue(withIdentifier: "phocationSegue1", sender: view)
    }
    
    // perform custom callout view for phocations
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        if view.annotation is MKUserLocation
        {
            return
        }

        let phAnnotation = view.annotation as! Phocation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        calloutView.phocationImage.contentMode = .scaleAspectFit
        calloutView.phocationImage.image = phAnnotation.image
        self.sendID = phAnnotation.id
        let button = UIButton(frame: calloutView.phocationImage.frame)
        button.addTarget(self, action: #selector(MyPhocationsViewController.showPhocation(sender:)), for: .touchUpInside)
        calloutView.addSubview(button)

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

//
//  ViewControllerMapView.swift
//  geo-quiz
//
//  Created by stefan on 12/17/16.
//  Copyright © 2016 stefan. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
  
  // 1
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    if let annotation = annotation as? Capital {
      let identifier = "pin"
      var view: MKPinAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        as? MKPinAnnotationView { // 2
        dequeuedView.annotation = annotation
        view = dequeuedView
      } else {
        // 3
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type:.detailDisclosure) as UIView
      }
      return view
    }
    return nil
  }
}

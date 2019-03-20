//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 19/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestStudents()
    }
    
    func setPin(lat: Double, long: Double) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.addAnnotation(annotation)
    }
    
    func requestStudents() {
        
        func sucess() {
            for item in Session.students {
                setPin(lat: item.latitude, long: item.longitude)
            }
        }
        
        func fail(msg: String) {
            
        }
        Requester().get(limit: 100, crescent: false, sucess: sucess, fail: fail)
    }
}

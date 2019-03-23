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
            for item in UserSession.students {
                setPin(lat: item.latitude ?? 0.0, long: item.longitude ?? 0.0)
            }
        }
        
        func fail(msg: String) {
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
        Requester().getStudents(limit: 100, crescent: false, sucess: sucess, fail: fail)
    }
}

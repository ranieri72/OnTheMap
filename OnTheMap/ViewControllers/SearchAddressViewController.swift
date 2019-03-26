//
//  SearchAddressViewController.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 23/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit
import MapKit

class SearchAddressViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var placemark: CLPlacemark?
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configMap()
    }
    
    func configMap() {
        let lat = placemark?.location?.coordinate.latitude ?? 0.0
        let long = placemark?.location?.coordinate.longitude ?? 0.0
        
        let userCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let eyeCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let mapCamera = MKMapCamera(lookingAtCenter: userCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 400.0)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.title = placemark?.name
        annotation.subtitle = placemark?.locality
        
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        mapView.addAnnotation(annotation)
        mapView.setCamera(mapCamera, animated: true)
    }
    
    @IBAction func finish(_ sender: UIButton) {
        requestSave()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func requestSave() {
        var user = StudentLocation()
        user.uniqueKey = UserSession.udacitySession?.account?.key
        user.firstName = UserSession.user?.first_name
        user.lastName = UserSession.user?.last_name
        user.mapString = placemark?.locality
        user.mediaURL = url
        user.latitude = placemark?.location?.coordinate.latitude
        user.longitude = placemark?.location?.coordinate.longitude
        
        func sucess() {
            dismiss(animated: true, completion: nil)
        }
        
        func fail(msg: String) {
            
        }
        Requester.postLocation(self, user: user, sucess: sucess, fail: fail)
        
    }
}

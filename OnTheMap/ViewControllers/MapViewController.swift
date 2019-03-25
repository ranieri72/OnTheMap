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
    
    let viewControllerID = "addStudentVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestStudents()
    }
    
    func setPin(student: StudentLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude ?? 0.0, longitude: student.longitude ?? 0.0)
        annotation.title = student.firstName
        annotation.subtitle = student.mediaURL
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func addStudent(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func reloadStudents(_ sender: UIBarButtonItem) {
        requestStudents()
    }
    
    func requestStudents() {
        
        func sucess() {
            for item in UserSession.students {
                setPin(student: item)
            }
        }
        
        func fail(msg: String) {
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
        Requester().getStudents(limit: 100, crescent: false, sucess: sucess, fail: fail)
    }
}

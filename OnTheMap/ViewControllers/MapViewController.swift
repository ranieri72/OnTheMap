//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 19/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let viewControllerID = "addStudentVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        requestStudents()
    }
    
    func setPin(student: StudentLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude ?? 0.0, longitude: student.longitude ?? 0.0)
        annotation.title = student.firstName
        annotation.subtitle = student.mediaURL
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let mediaURL: String? = view.annotation?.subtitle ?? ""
        guard let url = URL(string: mediaURL ?? "") else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func addStudent(_ sender: UIBarButtonItem) {
        requestUser()
    }
    
    @IBAction func reloadStudents(_ sender: UIBarButtonItem) {
        requestStudents()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        requestLogout()
    }
    
    func requestStudents() {
        
        func sucess() {
            for item in UserSession.students! {
                setPin(student: item)
            }
        }
        
        func fail(msg: String) {
            presentAlertView(msg: msg)
        }
        Requester.getStudents(self, limit: 100, crescent: false, sucess: sucess, fail: fail)
    }
    
    func requestUser() {
        
        func sucess() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: viewControllerID)
            present(controller, animated: true, completion: nil)
        }
        
        func fail(msg: String) {
            presentAlertView(msg: msg)
        }
        Requester.getStudent(self, sucess: sucess, fail: fail)
    }
    
    func requestLogout() {
        
        func sucess() {
            navigationController?.popViewController(animated: true)
        }
        
        func fail(msg: String) {
            presentAlertView(msg: msg)
        }
        Requester.logout(self, sucess: sucess, fail: fail)
    }
}

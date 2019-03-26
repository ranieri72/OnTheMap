//
//  AddStudentViewController.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 23/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit
import MapKit

class AddStudentViewController: UIViewController {
    
    @IBOutlet var tfAddress: UITextField!
    @IBOutlet var tfURL: UITextField!
    @IBOutlet var btnFindLocation: UIButton!
    
    let segueIdentifier = "addressSegueFromModal"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
        requestGeocode()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let view = segue.destination as! SearchAddressViewController
            let placemark = sender as! CLPlacemark
            view.placemark = placemark
            view.url = tfURL.text
        }
    }
    
    func requestGeocode() {
        
        func finish(placemark: CLPlacemark?, error: NSError?) {
            if error == nil {
                performSegue(withIdentifier: segueIdentifier, sender: placemark)
            } else {
                presentAlertView(msg: error?.localizedDescription ?? "Erro ao localizar endereço!")
            }
        }
        Requester.getCoordinate(self, addressString: tfAddress.text!, completionHandler: finish)
    }
}

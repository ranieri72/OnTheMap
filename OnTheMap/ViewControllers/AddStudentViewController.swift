//
//  AddStudentViewController.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 23/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit

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
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
}

//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 15/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var tfLogin: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var navigationBar: UINavigationItem!
    
    let segueIdentifier = "tabSegueFromLogin"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: UIButton) {
        performSegue(withIdentifier: segueIdentifier, sender: nil)
    }
}

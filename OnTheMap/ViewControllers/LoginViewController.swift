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
    // https://auth.udacity.com/sign-up
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: UIButton) {
        btnLogin.isEnabled = false
        var user = User()
        user.username = tfLogin.text!
        user.password = tfPassword.text!
        requestLogin(user: user)
    }
    
    func requestLogin(user: User) {
        
        func sucess() {
            btnLogin.isEnabled = true
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        }
        
        func fail(msg: String) {
            btnLogin.isEnabled = true
            tfPassword.text = ""
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        Requester().login(user: user, sucess: sucess, fail: fail)
    }
}

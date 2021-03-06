//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 15/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet var tfLogin: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    
    let segueIdentifier = "tabSegueFromLogin"
    
    @IBAction func login(_ sender: UIButton) {
        btnLogin.isEnabled = false
        var user = User()
        user.username = tfLogin.text!
        user.password = tfPassword.text!
        requestLogin(user: user)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    func requestLogin(user: User) {
        
        func sucess() {
            btnLogin.isEnabled = true
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        }
        
        func fail(msg: String) {
            btnLogin.isEnabled = true
            tfPassword.text = ""
            presentAlertView(msg: msg)
        }
        Requester.login(self, user: user, sucess: sucess, fail: fail)
    }
}

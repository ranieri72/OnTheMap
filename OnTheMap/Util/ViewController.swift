//
//  ViewController.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 25/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertView(msg: String) {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

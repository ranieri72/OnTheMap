//
//  Requester.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 18/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import MapKit

class Requester {
    
    private static var activityIndicator = UIActivityIndicatorView()
    private static var strLabel = UILabel()
    private static let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private static let udaticyUrl = "https://onthemap-api.udacity.com/v1/"
    private static let parseUrl = "https://parse.udacity.com/parse/classes/StudentLocation"
    
    private static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private static let parseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static func getStudents(_ view: UIViewController, limit: Int, crescent: Bool, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        let order = crescent ? "updatedAt" : "-updatedAt"
        let url = "\(parseUrl)?limit=\(limit)&order=\(order)"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if error == nil {
                    let students = try! JSONDecoder().decode(StudentLocation.self, from: data!)
                    UserSession.students = students.results!
                    sucess()
                } else {
                    fail(error?.localizedDescription ?? "Erro ao recuperar os estudantes!")
                }
                removeActivityIndicator()
            }
        }
        task.resume()
        addActivityIndicator(view)
    }
    
    static func login(_ view: UIViewController, user: User, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        var request = URLRequest(url: URL(string: "\(udaticyUrl)session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encodeData = try! JSONEncoder().encode(user)
        let stringData = String(data: encodeData, encoding: .utf8)!
        request.httpBody = "{\"udacity\": \(stringData)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if error == nil {
                    let range = (5..<data!.count)
                    let newData = data?.subdata(in: range)
                    let udacitySession = try! JSONDecoder().decode(UdacitySession.self, from: newData!)
                    if udacitySession.error == nil {
                        UserSession.udacitySession = udacitySession
                        sucess()
                    } else {
                        fail(udacitySession.error!)
                    }
                } else {
                    fail(error?.localizedDescription ?? "Erro durante o login!")
                }
                removeActivityIndicator()
            }
        }
        task.resume()
        addActivityIndicator(view)
    }
    
    static func logout(_ view: UIViewController, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        var request = URLRequest(url: URL(string: "\(udaticyUrl)session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if error == nil {
                    let range = (5..<data!.count)
                    let newData = data?.subdata(in: range)
                    UserSession.user = nil
                    UserSession.udacitySession = nil
                    sucess()
                    print(String(data: newData!, encoding: .utf8)!)
                } else {
                    fail(error?.localizedDescription ?? "Erro durante o logout!")
                }
                removeActivityIndicator()
            }
        }
        task.resume()
        addActivityIndicator(view)
    }
    
    static func getCoordinate(_ view: UIViewController,
                              addressString : String,
                              completionHandler: @escaping(CLPlacemark?, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        addActivityIndicator(view)
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            
            DispatchQueue.main.async {
                if error == nil {
                    if let placemark = placemarks?[0] {
                        completionHandler(placemark, nil)
                    }
                } else {
                    completionHandler(nil, error as NSError?)
                }
                removeActivityIndicator()
            }
        }
    }
    
    static func getStudent(_ view: UIViewController, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        let key = UserSession.udacitySession?.account!.key
        let request = URLRequest(url: URL(string: "\(udaticyUrl)users/\(key!)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if error == nil {
                    let range = (5..<data!.count)
                    let newData = data?.subdata(in: range)
                    let user = try! JSONDecoder().decode(User.self, from: newData!)
                    UserSession.user = user
                    sucess()
                    print(String(data: newData!, encoding: .utf8)!)
                } else {
                    fail(error?.localizedDescription ?? "Erro ao recuperar os dados do usuário!")
                }
                removeActivityIndicator()
            }
        }
        task.resume()
        addActivityIndicator(view)
    }
    
    static func postLocation(_ view: UIViewController, user: StudentLocation, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        var request = URLRequest(url: URL(string: parseUrl)!)
        request.httpMethod = "POST"
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let encodeData = try! JSONEncoder().encode(user)
        let stringData = String(data: encodeData, encoding: .utf8)!
        request.httpBody = stringData.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if error == nil {
                    sucess()
                    print(String(data: data!, encoding: .utf8)!)
                } else {
                    fail(error?.localizedDescription ?? "Erro ao salvar localização!")
                }
                removeActivityIndicator()
            }
        }
        task.resume()
        addActivityIndicator(view)
    }
    
    private static func addActivityIndicator(_ view: UIViewController) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = "Loading..."
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.view.frame.midX - strLabel.frame.width/2, y: view.view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.view.addSubview(effectView)
    }
    
    private static func removeActivityIndicator() {
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
    }
}

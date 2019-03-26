//
//  Requester.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 18/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import MapKit

class Requester {
    
    let udaticyUrl = "https://onthemap-api.udacity.com/v1/"
    let parseUrl = "https://parse.udacity.com/parse/classes/StudentLocation"
    
    let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let parseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    func getStudents(limit: Int, crescent: Bool, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        let order = crescent ? "updatedAt" : "-updatedAt"
        let url = "\(parseUrl)?limit=\(limit)&order=\(order)"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if error != nil {
                    fail(error?.localizedDescription ?? "Erro ao recuperar os estudantes!")
                    return
                }
                let students = try! JSONDecoder().decode(StudentLocation.self, from: data!)
                UserSession.students = students.results!
                sucess()
            }
        }
        task.resume()
    }
    
    func login(user: User, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
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
                if error != nil {
                    fail(error?.localizedDescription ?? "Erro durante o login!")
                    return
                }
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range)
                let udacitySession = try! JSONDecoder().decode(UdacitySession.self, from: newData!)
                if udacitySession.error == nil {
                    UserSession.udacitySession = udacitySession
                    sucess()
                } else {
                    fail(udacitySession.error!)
                }
            }
        }
        task.resume()
    }
    
    func logout(sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
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
                if error != nil {
                    fail(error?.localizedDescription ?? "Erro durante o logout!")
                    return
                }
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range)
                UserSession.user = nil
                UserSession.udacitySession = nil
                sucess()
                print(String(data: newData!, encoding: .utf8)!)
            }
        }
        task.resume()
    }
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLPlacemark?, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            
            DispatchQueue.main.async {
                if error == nil {
                    if let placemark = placemarks?[0] {
                        completionHandler(placemark, nil)
                        return
                    }
                }
                completionHandler(nil, error as NSError?)
            }
        }
    }
    
    func getStudent(sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        let key = UserSession.udacitySession?.account!.key
        let request = URLRequest(url: URL(string: "\(udaticyUrl)users/\(key!)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                if error != nil {
                    fail(error?.localizedDescription ?? "Erro ao recuperar os dados do usuário!")
                    return
                }
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range)
                let user = try! JSONDecoder().decode(User.self, from: newData!)
                UserSession.user = user
                sucess()
                print(String(data: newData!, encoding: .utf8)!)
            }
        }
        task.resume()
    }
    
    func postLocation(user: StudentLocation, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
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
                if error != nil {
                    fail(error?.localizedDescription ?? "Erro ao salvar localização!")
                    return
                }
                sucess()
                print(String(data: data!, encoding: .utf8)!)
            }
        }
        task.resume()
    }
}

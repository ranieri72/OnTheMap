//
//  Requester.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 18/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import Foundation

class Requester {
    
    let udaticyUrl = "https://onthemap-api.udacity.com/v1/session"
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
                    fail(error?.localizedDescription ?? "Erro!")
                    return
                }
                let students = try! JSONDecoder().decode(StudentLocation.self, from: data!)
                UserSession.students = students.results!
            }
        }
        task.resume()
    }
    
    func login(user: User, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        var request = URLRequest(url: URL(string: udaticyUrl)!)
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
                    fail(error?.localizedDescription ?? "Erro!")
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
    
    // FIXME:
    
    func post() {
        var request = URLRequest(url: URL(string: parseUrl)!)
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func put() {
        var request = URLRequest(url: URL(string: parseUrl)!)
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
}

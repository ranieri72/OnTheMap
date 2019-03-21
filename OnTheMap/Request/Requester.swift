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
    
    func get(limit: Int, crescent: Bool, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        let order = crescent ? "updatedAt" : "-updatedAt"
        let url = "\(parseUrl)?limit=\(limit)&order=\(order)"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                if let results = json["results"] as? [[String: AnyObject]] {
                    var students = [StudentLocation]()
                    for item in results {
                        let student = StudentLocation(json: item)
                        students.append(student)
                    }
                    Session.students = students
                }
                DispatchQueue.main.async {
                    sucess()
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    fail(error.localizedDescription)
                }
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func login(user: User, sucess: @escaping () -> Void, fail: @escaping (_ msg: String) -> Void) {
        var request = URLRequest(url: URL(string: udaticyUrl)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body, use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(user.username)\", \"password\": \"\(user.password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range)
            
            do {
                let json = try JSONSerialization.jsonObject(with: newData!, options: []) as! [String: AnyObject]
                
                if let error = json["error"] as? String {
                    DispatchQueue.main.async {
                        fail(error)
                    }
                    return
                }
                
                var requestUser = User()
                if let account = json["account"] as? [String: AnyObject],
                    let session = json["session"] as? [String: AnyObject] {
                    requestUser.key = account["key"] as? String ?? ""
                    requestUser.id = session["id"] as? String ?? ""
                }
                DispatchQueue.main.async {
                    Session.user = requestUser
                    sucess()
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    fail(error.localizedDescription)
                }
                print("Failed to load: \(error.localizedDescription)")
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

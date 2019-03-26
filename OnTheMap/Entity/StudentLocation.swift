//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 18/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    init() { }
    
    init(json: [String:AnyObject]) {
        objectId = json["objectId"] as? String ?? ""
        uniqueKey = json["uniqueKey"] as? String ?? ""
        firstName = json["firstName"] as? String ?? ""
        lastName = json["lastName"] as? String ?? ""
        mapString = json["mapString"] as? String ?? ""
        mediaURL = json["mediaURL"] as? String ?? ""
        latitude = json["latitude"] as? Double ?? 0.0
        longitude = json["longitude"] as? Double ?? 0.0
        createdAt = json["createdAt"] as? String ?? ""
        updatedAt = json["updatedAt"] as? String ?? ""
    }
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
    
    var results: [StudentLocation]?
}

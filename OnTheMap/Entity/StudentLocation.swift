//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 18/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    init(json: [String:AnyObject]) {
        objectId = json["objectId"] as? String ?? ""
        uniqueKey = json["uniqueKey"] as? String ?? ""
        firstName = json["firstName"] as? String ?? ""
        lastName = json["lastName"] as? String ?? ""
        mapString = json["mapString"] as? String ?? ""
        mediaURL = json["mediaURL"] as? String ?? ""
        latitude = json["latitude"] as? Double ?? 0.0
        longitude = json["longitude"] as? Double ?? 0.0
        createdAt = json["createdAt"] as? Data ?? Data()
        updatedAt = json["updatedAt"] as? Data ?? Data()
    }
    
    var objectId = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var latitude = 0.0
    var longitude = 0.0
    var createdAt = Data()
    var updatedAt = Data()
}

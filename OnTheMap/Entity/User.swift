//
//  User.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 19/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import Foundation

struct User {
    
    init() { }
    
    init(json: [String:AnyObject]) {
        key = json["key"] as? String ?? ""
        first_name = json["first_name"] as? String ?? ""
        last_name = json["last_name"] as? String ?? ""
    }
    
    var key = ""
    var first_name = ""
    var last_name = ""
}

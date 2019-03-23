//
//  User.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 19/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var first_name: String?
    var last_name: String?
    var username: String? = ""
    var password: String? = ""
}

//
//  UdacitySession.swift
//  OnTheMap
//
//  Created by Ranieri Aguiar on 21/03/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

struct UdacitySession: Codable {
    
    var error: String?
    var status: Int?
    
    var account: Account?
    var session: Session?
}

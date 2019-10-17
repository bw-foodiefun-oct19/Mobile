//
//  User.swift
//  FoodieFun
//
//  Created by John Kouris on 10/16/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct User: Codable {
    var userId: Int
    var username: String
    var password: String
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case password
        case token
    }
}

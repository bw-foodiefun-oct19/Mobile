//
//  User.swift
//  FoodieFun
//
//  Created by John Kouris on 10/17/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    let username: String
    let password: String
    let email: String?
    let firstName: String?
    let lastName: String?
}

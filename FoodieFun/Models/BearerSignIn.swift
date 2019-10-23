//
//  Token.swift
//  FoodieFun
//
//  Created by John Kouris on 10/17/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct BearerSignIn: Codable, Equatable {
    let message: String
    let token: String
}

//
//  Meal.swift
//  FoodieFun
//
//  Created by John Kouris on 10/17/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct Meal: Codable, Equatable {
    let id: Int?
    var restaurantName: String?
    var itemName: String
    let itemPhoto: String? //turn this into data and pust this up to the server and get url out of it
    let foodRating: Int?
    let itemComment: String?
    let dateVisited: String?
    let userId: Int?
}

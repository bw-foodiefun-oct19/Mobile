//
//  Experience.swift
//  FoodieFun
//
//  Created by John Kouris on 10/17/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct Experience: Codable, Equatable {
    var id: Int
    var restaurantName: String
    var restaurantType: String
    var itemName: String
    var itemPhoto: String
    var foodRating: Int
    var itemComment: String
    var waitTime: String
    var dateVisited: Date
    var userID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case restaurantName = "restaurant_name"
        case restaurantType = "restaurant_type"
        case itemName = "item_name"
        case itemPhoto = "item_photo"
        case foodRating = "food_rating"
        case itemComment = "item_comment"
        case waitTime = "wait_time"
        case dateVisited = "date_visited"
        case userID = "user_id"
    }
}

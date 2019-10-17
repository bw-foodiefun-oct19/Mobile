//
//  Meal.swift
//  FoodieFun
//
//  Created by John Kouris on 10/16/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct Meal: Codable {
    var id: Int
    var restaurantName: String
    var itemName: String
    var itemPhoto: String
    var foodRating: Int
    var itemComment: String
    var waitTime: String
    var dateVisited: Date
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case restaurantName = "restaurant_name"
        case itemName = "item_name"
        case itemPhoto = "item_photo"
        case foodRating = "food_rating"
        case itemComment = "item_comment"
        case waitTime = "wait_time"
        case dateVisited = "date_visited"
        case userId = "user_id"
    }
}

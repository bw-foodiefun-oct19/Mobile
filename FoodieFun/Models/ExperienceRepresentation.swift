//
//  ExperienceRepresentation.swift
//  FoodieFun
//
//  Created by John Kouris on 10/22/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct ExperienceRepresentation: Equatable, Codable {
    var id: Int?
    var restaurantName: String?
    var restaurantType: String?
    var itemName: String
    var itemPhoto: String?
    var foodRating: Int?
    var itemComment: String?
    var waitTime: String?
    var dateVisited: Date
    var userID: Int
}

struct ExperienceRepresentations: Codable {
    let results: [ExperienceRepresentation]
}

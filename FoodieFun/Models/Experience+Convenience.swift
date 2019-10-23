//
//  Experience+Convenience.swift
//  FoodieFun
//
//  Created by John Kouris on 10/22/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

extension Experience {
    
    var experienceRepresentation: ExperienceRepresentation? {
        guard let restaurantName = restaurantName else { return nil }
        return ExperienceRepresentation(id: Int(id), restaurantName: restaurantName, restaurantType: restaurantType ?? "", itemName: itemName ?? "", itemPhoto: itemPhoto ?? "", foodRating: Int(foodRating), itemComment: itemComment ?? "", waitTime: waitTime ?? "", dateVisited: Date(), userID: Int(userID))
    }
    
    convenience init(restaurantName: String, restaurantType: String, itemName: String, itemPhoto: String, foodRating: Int, itemComment: String, waitTime: String, dateVisited: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.restaurantName = restaurantName
        self.restaurantType = restaurantType
        self.itemName = itemName
        self.itemPhoto = itemPhoto
        self.foodRating = Int16(foodRating)
        self.itemComment = itemComment
        self.waitTime = waitTime
        self.dateVisited = dateVisited
    }
    
    @discardableResult convenience init?(experienceRepresentation: ExperienceRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
    }
    
//    var movieRepresentation: MovieRepresentation? {
//        guard let title = title else { return nil }
//        return MovieRepresentation(title: title, identifier: identifier ?? UUID(), hasWatched: hasWatched)
//    }
//
//    convenience init(title: String, identifier: UUID = UUID(), hasWatched: Bool = false, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        self.init(context: context)
//
//        self.title = title
//        self.identifier = identifier
//        self.hasWatched = hasWatched
//    }
//
//    @discardableResult convenience init?(movieRepresentation: MovieRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        guard let identifier = movieRepresentation.identifier,
//            let hasWatched = movieRepresentation.hasWatched else { return nil }
//        self.init(title: movieRepresentation.title, identifier: identifier, hasWatched: hasWatched, context: context)
//    }
}

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
        guard let itemName = itemName else { return nil }
        
        let dateFormatter = DateFormatter()
        let dateString = dateFormatter.string(from: Date())
        
        return ExperienceRepresentation(id: Int(id),
                                        restaurantName: restaurantName ?? "",
                                        restaurantType: restaurantType ?? "",
                                        itemName: itemName,
                                        itemPhoto: itemPhoto ?? "",
                                        foodRating: Int(foodRating),
                                        itemComment: itemComment ?? "",
                                        waitTime: waitTime ?? "",
                                        dateVisited: dateString,
                                        userID: Int(userID))
    }
    
    convenience init(restaurantName: String?,
                     restaurantType: String?,
                     itemName: String,
                     itemPhoto: String?,
                     foodRating: Int?,
                     itemComment: String?,
                     waitTime: String?,
                     dateVisited: String?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.restaurantName = restaurantName
        self.restaurantType = restaurantType
        self.itemName = itemName
        self.itemPhoto = itemPhoto
        self.foodRating = Int16(foodRating ?? 0)
        self.itemComment = itemComment
        self.waitTime = waitTime
        self.dateVisited = dateVisited
    }
    
    @discardableResult convenience init?(experienceRepresentation: ExperienceRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
    }
    
}

//
//  MealTableViewCell.swift
//  FoodieFun
//
//  Created by Dongwoo Pae on 10/23/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var foodnameLabel: UILabel!
    
    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    
    var meal: Meal? {
        didSet {
            self.updateViews()
        }
    }
    
    let backgroundImageArray = ["saladBG.jpg", "mealBG", "pizzaBG", "pitaBG", "steakBG", "tritipBG", "toastBG", "twoSaladsBG"]
    let randomNumber = Int.random(in: 0...7)
    
    private func updateViews() {
        guard let meal = meal else {return}
        let ratingInt = meal.foodRating
        let ratingString = String(ratingInt!)
        self.rateLabel?.text = "\(ratingString)/ 5"
        
        //dateFormatter
        //        let formatter = DateFormatter()
        //        formatter.dateStyle = .medium
        //        formatter.timeStyle = .none
        //
        //        formatter.locale = Locale(identifier: "en_US")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T00':HH:mm:sssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        
        let dateFromServer = meal.dateVisited
        let date = dateFormatter.date(from: dateFromServer!)
        
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let dateString = dateFormatter.string(from: date!)
        print(dateString)
        
        
        self.dateLabel?.text = dateString
        print(meal.dateVisited)
        
        self.restaurantNameLabel?.text = meal.restaurantName
        self.foodnameLabel?.text = meal.itemName
        
        self.cellBackgroundImageView.image = UIImage(named: "\(backgroundImageArray[randomNumber]).jpg")!
        self.cellBackgroundImageView.alpha = 0.4
        self.cellBackgroundImageView.layer.cornerRadius = 14
    }
}

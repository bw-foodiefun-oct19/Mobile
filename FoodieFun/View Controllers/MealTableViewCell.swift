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
        self.rateLabel?.text = ratingString
        self.dateLabel?.text = meal.dateVisited
        self.restaurantNameLabel?.text = meal.restaurantName
        self.foodnameLabel?.text = meal.itemName
        
        self.cellBackgroundImageView.image = UIImage(named: "\(backgroundImageArray[randomNumber]).jpg")!
        self.cellBackgroundImageView.alpha = 0.4
        self.cellBackgroundImageView.layer.cornerRadius = 14
    }
}

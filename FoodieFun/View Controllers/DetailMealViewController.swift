//
//  DetailMealViewController.swift
//  FoodieFun
//
//  Created by Dongwoo Pae on 10/22/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class DetailMealViewController: UIViewController {
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var itemnameTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    
    var apiController: APIController!
    var meal: Meal? {
        didSet {
            self.updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func updateViews() {
        guard let meal = self.meal else {return}
        self.itemnameTextField?.text = meal.itemName
        self.restaurantNameTextField?.text = meal.restaurantName
        self.ratingTextField?.text = String(meal.foodRating ?? 0)
        self.commentTextField?.text = meal.itemComment
    }
    
    @IBAction func saveMealButtonTapped(_ sender: Any) {
        guard let itemname = self.itemnameTextField.text,
            let restaurantName = self.restaurantNameTextField.text,
            let foodRating = self.ratingTextField.text,
            let comment = self.commentTextField.text else {
                
                //Alert
                
                return
        }
        
        
        if let meal = self.meal {
            self.apiController.updateMeal(for: meal, changeitemNameto: itemname, changerestaurantNameto: restaurantName, changeitemPhototo: "", changefoodRatingto: Int(foodRating), changeitemCommentto: comment ) { (error) in
                if let error = error {
                    print(error)
                }
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            self.apiController.createMeal(for: itemname, restaurantName: restaurantName, itemPhoto: nil, foodRating: Int(foodRating), comment: comment) { (error) in
                //code 201 is actaully 201 created (postman)
                if let error = error {
                    print("error in creating meal:\(error)")
                }
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}


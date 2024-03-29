//
//  AddExperienceViewController.swift
//  FoodieFun
//
//  Created by Casualty on 10/22/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class AddExperienceViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var cuisineTypeTextField: UITextField!
    @IBOutlet weak var menuItemTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var shareExperienceButton: UIButton!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet var ratingLabel: UITextField!
    
    var apiController: APIController?
    
    var experience: Experience?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRestaurantName()
        detectTap()
        styleElements()
        updateViews()
    }
    
    @IBAction func shareExperienceTapped(_ sender: Any) {
        guard let restaurantName = restaurantNameTextField.text,
            let itemName = menuItemTextField.text,
            !restaurantName.isEmpty,
            !itemName.isEmpty else { return }
        
        if let experience = experience {
            apiController?.updateExperience(experience: experience,
                                            itemName: itemName,
                                            restaurantName: restaurantName,
                                            restaurantType: cuisineTypeTextField.text ?? "",
                                            itemPhoto: "",
                                            foodRating: Int(ratingLabel.text ?? "1"),
                                            itemComment: reviewTextView.text ?? "",
                                            waitTime: "",
                                            dateVisited: experience.dateVisited)
        } else {
            let dateFormatter = DateFormatter()
            experience?.dateVisited = dateFormatter.string(from: Date())
            apiController?.createExperience(itemName: itemName,
                                            restaurantName: restaurantName,
                                            restaurantType: cuisineTypeTextField.text ?? "",
                                            itemPhoto: "",
                                            foodRating: Int(ratingLabel.text ?? "1"),
                                            itemComment: reviewTextView.text,
                                            waitTime: "",
                                            dateVisited: experience?.dateVisited)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setRestaurantName() {
        restaurantNameTextField.text = selectedRestaurantTitle
    }
    
    func detectTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }
    
    func styleElements() {
        Utilities.styleFilledButton(shareExperienceButton)
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1)
        reviewTextView.layer.cornerRadius = 5
    }
    
    func updateViews() {
        if let experience = experience {
            experienceLabel.text = "Edit Experience"
            shareExperienceButton.setTitle("Update", for: .normal)
            restaurantNameTextField.text = experience.restaurantName
            menuItemTextField.text = experience.itemName
            cuisineTypeTextField.text = experience.restaurantType
            reviewTextView.text = experience.itemComment
            ratingLabel.text = "\(experience.foodRating)"
        }
    }
    
}

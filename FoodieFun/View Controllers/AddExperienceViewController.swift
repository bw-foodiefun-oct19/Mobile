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
    
    var apiController: APIController?
    
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRestaurantName()
        detectTap()
        styleElements()
    }
    
    @IBAction func shareExperienceTapped(_ sender: Any) {
        guard let restaurantName = restaurantNameTextField.text,
            let itemName = menuItemTextField.text,
            !restaurantName.isEmpty,
            !itemName.isEmpty else { return }
        
        if let experience = experience {
            print("to be updated")
        } else {
            apiController?.createExperience(itemName: itemName, restaurantName: restaurantName, restaurantType: cuisineTypeTextField.text ?? "", itemPhoto: "", foodRating: Int.random(in: 1...5), itemComment: reviewTextView.text, waitTime: "", dateVisited: Date())
        }
        navigationController?.popToRootViewController(animated: true)
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
        restaurantNameTextField.text = experience?.restaurantName
        menuItemTextField.text = experience?.itemName
        cuisineTypeTextField.text = experience?.restaurantType
        reviewTextView.text = experience?.itemComment
    }
    
}

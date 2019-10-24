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
            let menuItem = menuItemTextField.text,
            !restaurantName.isEmpty,
            !menuItem.isEmpty else { return }
        
        let _ = Experience(restaurantName: restaurantName, restaurantType: cuisineTypeTextField.text ?? "", itemName: menuItem, itemPhoto: "", foodRating: 0, itemComment: reviewTextView.text, waitTime: "", dateVisited: Date(), context: CoreDataStack.shared.mainContext)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
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
        
        
    }
    
}

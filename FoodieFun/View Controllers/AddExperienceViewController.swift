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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRestaurantName()
        detectTap()
    }
    
    func setRestaurantName() {
        restaurantNameTextField.text = selectedRestaurantTitle
    }
    
    func detectTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }
    
}

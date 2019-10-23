//
//  AddExperienceViewController.swift
//  FoodieFun
//
//  Created by Casualty on 10/22/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class AddExperienceViewController: UIViewController {
    @IBOutlet weak var restaurantNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRestaurantName()

        // Do any additional setup after loading the view.
    }
    
    func setRestaurantName() {
        restaurantNameTextField.text = selectedRestaurantTitle
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SignUpViewController.swift
//  FoodieFun
//
//  Created by John Kouris on 10/17/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    var apiController = APIController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        guard let username = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            !firstName.isEmpty,
            !lastName.isEmpty,
            !username.isEmpty,
            !confirmPassword.isEmpty,
            !password.isEmpty else {
                let ac = UIAlertController(title: "Sign Up Failed", message: "Please fill in all the fields before trying to sign up.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
                return
        }
        
        guard confirmPassword == password else {
            let ac = UIAlertController(title: "Error", message: "Passwords do not match. Please try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        let user = User(username: username, password: password)
        
        signUp(with: user)
    }
    
    
    func signUp(with user: User) {
        apiController.signUp(with: user, completion: { (error) in
            if let error = error {
                print("Error signing up: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
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

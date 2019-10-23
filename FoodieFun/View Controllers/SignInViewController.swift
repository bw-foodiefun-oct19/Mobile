//
//  SignInViewController.swift
//  FoodieFun
//
//  Created by John Kouris on 10/18/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    var apiController: APIController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        loadFromDefaults()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(signUpButton)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = emailTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else {
                let ac = UIAlertController(title: "Login Failed", message: "Wrong email or password. Please try again.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
                return
        }
        
        let user = User(username: username, password: password)
        
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        
        signIn(with: user)
    }
    
    func signIn(with user: User) {
        apiController?.signIn(with: user) { (error) in
            if let error = error {
                print("Error occurred during sign in: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func loadFromDefaults() {
        emailTextField.text = UserDefaults.standard.string(forKey: "username") ?? ""
        passwordTextField.text = UserDefaults.standard.string(forKey: "password") ?? ""
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

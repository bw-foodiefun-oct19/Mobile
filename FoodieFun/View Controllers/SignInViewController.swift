//
//  SignInViewController.swift
//  FoodieFun
//
//  Created by John Kouris on 10/18/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    var apiController: APIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
             let password = passwordTextField.text,
             !username.isEmpty,
             !password.isEmpty else { return }

        let user = User(username: username, password: password, email: nil, firstName: nil, lastName: nil)
        
        self.apiController.signIn(with: user) { (error) in
            if let error = error {
                NSLog("error in signing up: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
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

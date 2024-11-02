//
//  ViewController.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 27/09/2020.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var swapRegisterButton: UIButton!
    //Setting up the auto-login feature
    override func viewDidLoad() {
        navigationItem.hidesBackButton = true
        if Auth.auth().currentUser != nil {
            let vc = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as! MainTabBarController
            vc.selectedViewController = vc.viewControllers?[0]
            self.present(vc, animated: false, completion: nil)
//            if let vc = self.storyboard?.instantiateViewController(identifier: "Home_vc") {
//                self.navigationController?.pushViewController(vc, animated: false)
//            }
        }
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        //hides the keyboard when the user taps outside of keyboard
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        loginButton.isEnabled = false
        let email = emailField.text
        let password = passwordField.text
        let testClass = UserInformationTest()
        guard testClass.checkPresence(email: email, password: password) == true else {
            displayAlert(message: "Please fill in both fields", title: "Oops!")
            self.loginButton.isEnabled = true
            return
        }
        guard testClass.checkEmail(email: email!) == true else {
            displayAlert(message: "Please enter a valid email", title: "Oops!")
            self.loginButton.isEnabled = true
            return
        }
        guard testClass.checkPasswordLength(password: password!) == true else {
            displayAlert(message: "Please enter a password that is at least 8 characters long", title: "Oops!")
            self.loginButton.isEnabled = true
            return
        }
        Auth.auth().signIn(withEmail: email!, password: password!) { authResult, error in
            if error != nil {
                self.displayAlert(message: "Incorrect email or password", title: "Oops!")
                self.loginButton.isEnabled = true
            } else {
                let vc = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as! MainTabBarController
                vc.selectedViewController = vc.viewControllers?[0]
                self.present(vc, animated: true, completion: nil)
//                if let vc = self.storyboard?.instantiateViewController(identifier: "Home_vc") {
//                    self.navigationController?.pushViewController(vc, animated: false)
//                }
            }
        }
    }
    
    func displayAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) //instantiating a UIAlert controller
        alert.addAction(UIAlertAction(title: "Continue", style: .default))
        //adding an UI alert action
        self.present(alert, animated: true)
    }
    
    @IBAction func swapRegisterButtonTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "Register_vc") {
            self.navigationController?.pushViewController(vc, animated: false)
        }
        //hides the keyboard when the user taps return
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


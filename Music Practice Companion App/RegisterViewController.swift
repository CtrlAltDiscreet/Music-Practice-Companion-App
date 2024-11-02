//
//  RegisterViewController.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 04/10/2020.
//

import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController{
    
    @IBOutlet var regEmailField: UITextField!
    @IBOutlet var regPasswordField: UITextField!
    @IBOutlet var registerButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        regEmailField.delegate = self
        regPasswordField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        regEmailField.resignFirstResponder()
        regPasswordField.resignFirstResponder()
        //hides the keyboard when user taps outside the keyboard
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        registerButton.isEnabled = false
        let email = regEmailField.text
        let password = regPasswordField.text
        let testClass = UserInformationTest()
        guard testClass.checkPresence(email: email, password: password) == true else {
            displayAlert(message: "Please fill in both fields", title: "Oops!")
            self.registerButton.isEnabled = true //shows an alert if incorrectly filled in
            return //checking the presence of the fields
        }
        guard testClass.checkEmail(email: email!) == true else {
            displayAlert(message: "Please enter a valid email", title: "Oops!")
            self.registerButton.isEnabled = true
            return
        }
        guard testClass.checkPasswordLength(password: password!) == true else {
            displayAlert(message: "Please enter a password that is at least 8 characters long", title: "Oops!")
            self.registerButton.isEnabled = true
            return
        }
        Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                //sending the email and password off to firebase
            }
        }
        if let vc = storyboard?.instantiateViewController(identifier: "Home_vc") {
            self.navigationController?.pushViewController(vc, animated: false)
            //changing the view controller to the home view controller
        }
        
    }
    
    func displayAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) //instantiating a UIAlert controller
        alert.addAction(UIAlertAction(title: "Continue", style: .default)) //adding an UI alert action
        self.present(alert, animated: true)
    }
    
}

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        //hides the keyboard when the user taps return
    }
}



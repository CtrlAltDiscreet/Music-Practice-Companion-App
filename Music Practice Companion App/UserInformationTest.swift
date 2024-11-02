//
//  UserInformationTest.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 04/10/2020.
//

import Foundation

class UserInformationTest {

    //checks if all fields have been entered
    func checkPresence(email: String?, password: String?) -> Bool {
        if email == "" || password == ""{
            print("Please fill in all the fields")
            return false
        } else {
            return true
        }
    }

    //checks whether email entered is valid
    func checkEmail(email: String) -> Bool {
        let email = email
        
        //set the example email
        let exampleEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        //test the email
        let testEmail = NSPredicate(format:"SELF MATCHES %@", exampleEmail)
        if testEmail.evaluate(with: email) == false {
            return false
        }
        else {
            return true
        }
    }
    
    //checks the password length
    func checkPasswordLength(password: String) -> Bool {
        let length = password.count
        if length >= 8 {
            return true
        } else {
            print("Password must be at least 8 characters long")
            return false
        }
    }
    
}


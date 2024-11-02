//
//  AddEventsViewController.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 29/11/2020.
//

import UIKit

var events : [Event] = []

class AddEventsViewController: UIViewController {

    @IBOutlet var eventNameField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    //links the eventNameField and datePicker from the storyboard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        //adds button on the tab bar
        datePicker.preferredDatePickerStyle = .inline
        //sets the datePicker's style
        eventNameField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        eventNameField.resignFirstResponder()
        //hides the keyboard when the user taps outside of keyboard
    }
    
    @objc func addTapped() {
        //Validation
        if eventNameField.text! == "" {
            //instantiating a UIAlert controller
            let alert = UIAlertController(title: "Oops!", message: "Please enter an event name.", preferredStyle: .alert)
            //adding an UI alert action
            alert.addAction(UIAlertAction(title: "Continue", style: .default))
            self.present(alert, animated: true)
        } else {
            let eventName = eventNameField.text!
            print(eventName)
            
    //        datePicker.datePickerMode = UIDatePicker.Mode.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let eventDate = dateFormatter.string(from: datePicker.date)
            print(eventDate)
            //gets the date in the datePicker and assigns it to eventDate

            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let eventTime = timeFormatter.string(from: datePicker.date)
            print(eventTime)
            //gets the time in the datePicker and assigns it to eventTime

            let event = Event(name: eventName, startDate: eventDate, startTime: eventTime)
            //initialises event class with needed attributes
            events.append(event)
            
            if let encodedEvents = try? NSKeyedArchiver.archivedData(withRootObject: events, requiringSecureCoding: false) {
                UserDefaults.standard.set(encodedEvents, forKey: "storedEventsArray")
                //encodes the events array, and stores it in user defaults, under the key "storedEventsArray"
            }
            
            navigationController?.popToRootViewController(animated: true)
        }
        
    }

}

extension AddEventsViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

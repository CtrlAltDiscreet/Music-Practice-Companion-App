//
//  DailyEventsViewController.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 28/11/2020.
//

import UIKit

class DailyEventsViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet var collectionView: UICollectionView!
    var date: String!
    var allEvents: [Event]!
    var numberOfCells: Int = 24
    var numberOfEvents: Int = 0
    //declaring variables

    override func viewDidLoad() {
        super.viewDidLoad()
        if events.count > 0 {
            //checks if there are any events
            for event in events {
                if event.startDate == date {
                    numberOfEvents += 1
                }
            }
        }
        //setting the title
        if numberOfEvents == 1 {
            navigationItem.title = "\(date!)   (\(numberOfEvents))"
        } else {
            navigationItem.title = "\(date!)   (\(numberOfEvents))"
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let storedEvents = userDefaults.object(forKey: "storedEventsArray") {
            events = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedEvents as! Data) as! [Event]
        }
        //reads from database and sets storedEventsArray as storedEvents
        
        for event in events {
            if event.startDate == self.date {
                numberOfCells += 1
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        allEvents = events
    }
    
    @IBAction func addEventButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "AddEventViewController") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func createChangeNameAlert(cell: HourCell, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Change name of event", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { textField in
            textField.text = cell.eventNameLabel.text
            //sets the default text in the text field as the current name of cell.
        })
        alert.addAction(UIAlertAction(title: "Update", style: UIAlertAction.Style.default, handler: { (_) in
            cell.eventNameLabel.text = alert.textFields!.first!.text
            //changes the name of the cell to what is in the text field.
            for event in events {
                if event.startTime.prefix(2) == cell.hourLabel.text!.prefix(2) && event.startDate == self.date {
                    event.name = alert.textFields!.first!.text!
                    //checks same time and date, and if matches, changes the name of the event in the array events
                }
            }
            if let encodedEvents = try? NSKeyedArchiver.archivedData(withRootObject: events, requiringSecureCoding: false) {
                UserDefaults.standard.set(encodedEvents, forKey: "storedEventsArray")
                //overwrites the userdefaults data at storage location "storedEventsArray"
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func createChangeTimeAlert(cell: HourCell, indexPath: IndexPath) {

        let editDatePicker: UIDatePicker = UIDatePicker()
        editDatePicker.timeZone = TimeZone.current
        editDatePicker.preferredDatePickerStyle = .wheels
        editDatePicker.frame = CGRect(x: 0, y: 15, width: 275, height: 200)
        //sets the size constraints for the datePicker
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        //provides blank space for the datePicker
        alertController.view.addSubview(editDatePicker)
        let selectAction = UIAlertAction(title: "Update", style: .default, handler: { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let newEventDate = dateFormatter.string(from: editDatePicker.date)
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let newEventTime = timeFormatter.string(from: editDatePicker.date)
            print(editDatePicker.date)
            
            cell.hourLabel.text = newEventTime
            for event in events {
                if event.name == cell.eventNameLabel.text! && event.startDate == self.date {
                    event.startDate = newEventDate
                    event.startTime = newEventTime
                    //checks same name and date, and if matches, updates the time and the date of the event
                }
            }
            if let encodedEvents = try? NSKeyedArchiver.archivedData(withRootObject: events, requiringSecureCoding: false) {
                UserDefaults.standard.set(encodedEvents, forKey: "storedEventsArray")
                //overwrites the userdefaults data at storage location "storedEventsArray"
            }
            self.collectionView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        
    }
    
    func checkColonInName(time: String) -> Bool {
        var hasColon = false
        for character in time {
            if character == ":" {
                hasColon = true
            }
        }
        return hasColon
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath)?.backgroundColor == UIColor.gray {
            //selection to check if event exists
            guard let cell = collectionView.cellForItem(at: indexPath) as? HourCell else {
                fatalError()
            }
            let alert = UIAlertController(title: "Edit Event", message: "", preferredStyle: UIAlertController.Style.alert)
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Change name", style: UIAlertAction.Style.default, handler: { (_) in
                self.createChangeNameAlert(cell: cell, indexPath: indexPath)
            }))
            alert.addAction(UIAlertAction(title: "Change date and time", style: UIAlertAction.Style.default, handler: { (_) in
                self.createChangeTimeAlert(cell: cell, indexPath: indexPath)
            }))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (_) in
                cell.backgroundColor = UIColor.white
                cell.eventNameLabel.text = nil
                cell.eventNameLabel.isHidden = true
                cell.hourLabel.textColor = UIColor.black
                
                //Updating the Event Count Title
                self.numberOfEvents -= 1
                if self.numberOfEvents == 1 {
                    self.navigationItem.title = "\(self.date!)   (\(self.numberOfEvents))"
                } else {
                    self.navigationItem.title = "\(self.date!)   (\(self.numberOfEvents))"
                }
                
                //Updating the rest of the cells
                if indexPath.item < 10 {
                    cell.hourLabel.text = "0\(indexPath.item):00"
                } else {
                    cell.hourLabel.text = "\(indexPath.item):00"
                }
                for event in events {
                    if event.startTime.prefix(2) == cell.hourLabel.text!.prefix(2) && event.startDate == self.date {
                        events.removeAll { $0.name == event.name }
                        //checks same time and date, and if matches, removes the event
                    }
                }
                print("deleting")
                if let encodedEvents = try? NSKeyedArchiver.archivedData(withRootObject: events, requiringSecureCoding: false) {
                    UserDefaults.standard.set(encodedEvents, forKey: "storedEventsArray")
                    //overwrites the userdefaults data at storage location "storedEventsArray"
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension DailyEventsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCells - numberOfEvents
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as? HourCell else {
            fatalError()
        }
        
        // Hour
        if indexPath.item < 10 {
            cell.hourLabel.text = "0\(indexPath.item):00"
        } else {
            cell.hourLabel.text = "\(indexPath.item):00"
        }
        
        //Cell Design
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.backgroundColor = UIColor.white
        cell.hourLabel.textColor = UIColor.black
        cell.eventNameLabel.isHidden = true
        
        // Event Name
        
        if events.count > 0 {
            //checks if there are any events
            for event in events {
                if event.startTime.prefix(2) == cell.hourLabel.text!.prefix(2) && event.startDate == date {
                    //compares the times
                    //changes the cells
                    cell.hourLabel.text = event.startTime
                    cell.eventNameLabel.text = event.name
                    cell.backgroundColor = UIColor.gray
                    cell.hourLabel.textColor = UIColor.white
                    cell.eventNameLabel.isHidden = false
                    cell.eventNameLabel.textColor = UIColor.white
                }
            }
        }
        
        
        return cell
    }
}

extension DailyEventsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 30)
    }
}


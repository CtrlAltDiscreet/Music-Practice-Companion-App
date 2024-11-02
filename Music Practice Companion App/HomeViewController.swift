//
//  HomeViewController.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 07/10/2020.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var signOutButton: UIButton!
    @IBOutlet var dailyEventTableView: UITableView!
    let userDefaults = UserDefaults.standard
    //synatax for accessing the database
    @IBOutlet var streakLabel: UILabel!
    var eventsToday: [String] = []
    @IBOutlet var eventLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        //gets yesterday's date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        //initialises the formatter, and tells it what type.
        let yesterdayAsString = formatter.string(from: yesterday!)
        let today = Date()
        let todayAsString = formatter.string(from: today)
        //sets the label name
        eventLabel.text = "Events for today, \(todayAsString)"
        //converting into stringc
        if let storedDate = userDefaults.string(forKey: "lastLoginDate") {
        //checks if there is a stored userDefaults variable called "storedDate"
            if storedDate == yesterdayAsString {
                userDefaults.set(userDefaults.integer(forKey: "streak") + 1, forKey: "streak")
                //increments the streak variable by 1
                streakLabel.text = userDefaults.string(forKey: "streak")
                userDefaults.set(todayAsString, forKey: "lastLoginDate")
                //sets the today's date as the new "lastLoginDate"
            } else if storedDate == todayAsString {
                streakLabel.text = userDefaults.string(forKey: "streak")
            } else {
                userDefaults.set(0, forKey: "streak")
                userDefaults.set(todayAsString, forKey: "lastLoginDate")
                streakLabel.text = "0"
            }
        } else {
            userDefaults.set(todayAsString, forKey: "lastLoginDate")
            streakLabel.text = "0"
        }
        
        if let storedEvents = userDefaults.object(forKey: "storedEventsArray") {
            events = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedEvents as! Data) as! [Event]
        }
        //reads from database and sets storedEventsArray as storedEvents
        
        for event in events {
            if event.startDate == todayAsString {
                print("item exists")
                eventsToday.append("\(event.name) - \(event.startTime)")
            }
        }
        //checks if there are any events today, and appends it to the array with the name and time.
        
    }
    
    //appends any new events immediately to the home screen
    override func viewDidAppear(_ animated: Bool) {
        eventsToday = []
        viewDidLoad()
        dailyEventTableView.reloadData()
    }
    
    //Setting up the sign out button
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let vc = self.storyboard?.instantiateViewController(identifier: "Login_vc") {
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        } catch let error {
            print(error)
        }
    }
    
    //Setting up table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsToday.count
    }
    
    //Settng each the name of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(eventsToday[indexPath.row])
        return cell
    }
    
}

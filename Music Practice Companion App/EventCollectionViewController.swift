//
//  EventCollectionViewController.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 18/11/2020.
//

import UIKit

class EventCollectionViewController: UICollectionViewController {
    
    var dates: [Int] = []
    var days: [String] = ["S","M","T","W","T","F","S"]
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDate: Date = Date()
    var zeros = 0
    //declaration of variables

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let now = Date()
        let currentMonthInt = Calendar.current.component(.month, from: now)
        //gets the current month as an integer
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        //initialises the date formatter
        let nameOfMonth = dateFormatter.string(from: now)
        //gets the name of the month
        let yearInt = Calendar.current.component(.year, from: Date())
        let monthAndYear = nameOfMonth + " " + String(yearInt)
        navigationItem.title = monthAndYear
        //sets the navigation bar title to monthAndYear
        currentYear = yearInt
        currentMonth = currentMonthInt
        settingDates()
        
    }
    
    func settingDates() {
        dates = []
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: currentYear, month: currentMonth)
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        //gets number of days in a month
        zeros = 0
        
        let weekday = calendar.date(byAdding: .day, value: 0, to: date)!.dayOfWeek()!
        let fullCurrentDay = String(weekday)
        //gets which day of the week the 1st of the month corresponds to.
        if fullCurrentDay == "Sunday" {
            zeros = 0
        }else if fullCurrentDay == "Monday" {
            zeros = 1
        }else if fullCurrentDay == "Tuesday" {
            zeros = 2
        }else if fullCurrentDay == "Wednesday" {
            zeros = 3
        }else if fullCurrentDay == "Thursday" {
            zeros = 4
        }else if fullCurrentDay == "Friday" {
            zeros = 5
        }else if fullCurrentDay == "Saturday" {
            zeros = 6
        }
        for _ in 0..<zeros {
            dates.append(0)
            //appends the number of zeros to the dates array
        }
        
        for count in 1...numDays {
            dates.append(count)
            let date = calendar.date(byAdding: .day, value: count, to: Date())
            if let weekday = date?.dayOfWeek() {
                days.append(String(weekday.prefix(1)))
            } else {
                days.append("N/A")
            }
        }
        collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    @IBAction func rightArrowToggled(_ sender: Any) {
        updateTitleAndVariables(increment: 1)
    }
    
    @IBAction func leftArrowToggled(_ sender: Any) {
        updateTitleAndVariables(increment: -1)
    }
    
    func updateTitleAndVariables(increment: Int) {
        let nextMonth = Calendar.current.date(byAdding: .month, value: increment, to: currentDate)!
        //finding the date of the next month
        let nextMonthInt = Calendar.current.component(.month, from: nextMonth)
        //finding the integer of that month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        currentMonth = nextMonthInt
        currentDate = nextMonth
        //updates global variables
        let nameOfMonth = dateFormatter.string(from: currentDate)
        let yearInt = Calendar.current.component(.year, from: currentDate)
        let monthAndYear = nameOfMonth + " " + String(yearInt)
        navigationItem.title = monthAndYear
        currentYear = yearInt
        settingDates()
    }
    
    @IBAction func addEventButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "AddEventViewController") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count + 7
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "date", for: indexPath) as? DateCell else {
            fatalError()
        }
        if indexPath.item <= 6 {
            cell.dateLabel.text = days[indexPath.item]
            cell.dateLabel.textColor = UIColor.systemRed
        } else {
            if dates[indexPath.item-7] == 0 {
                cell.dateLabel.text = ""
            } else {
                cell.dateLabel.text = String(dates[indexPath.item-7])
                cell.dateLabel.textColor = UIColor.black
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item > 6 + zeros {
            //checks if indexPath.item is greater than the red weekdays and the empty slots.
            guard let viewController = storyboard?.instantiateViewController(identifier: "DailyEventsViewController") as? DailyEventsViewController else {
                fatalError()
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? DateCell {
                if cell.dateLabel.text!.count == 1 {
                    if currentMonth < 10 {
                        viewController.date = "0" + cell.dateLabel.text! + "/" + "0" + "\(currentMonth)" + "/" + "\(currentYear)"
                    } else {
                        viewController.date = "0" + cell.dateLabel.text! + "/" + "\(currentMonth)" + "/" + "\(currentYear)"
                    }
                    
                } else {
                    if currentMonth < 10 {
                        viewController.date = cell.dateLabel.text! + "/" + "0" + "\(currentMonth)" + "/" + "\(currentYear)"
                    } else {
                        viewController.date = cell.dateLabel.text! + "/" + "\(currentMonth)" + "/" + "\(currentYear)"
                    }
                    
                }
                
                //sets the text of the new view controller to be the date that has been clicked.
            } else {
                fatalError()
            }
            self.navigationController?.pushViewController(viewController, animated: true)
            //brings the user to the DailyEventsViewController.
        }
    }
    
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

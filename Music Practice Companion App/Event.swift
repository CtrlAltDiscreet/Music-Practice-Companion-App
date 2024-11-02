//
//  Event.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 18/11/2020.
//

import Foundation

class Event: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(startDate, forKey: "startDate")
        coder.encode(startTime, forKey: "startTime")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        startDate = coder.decodeObject(forKey: "startDate") as! String
        startTime = coder.decodeObject(forKey: "startTime") as! String
    }
    
    var name: String
    var startDate: String
    var startTime: String
    
    init(name: String, startDate: String, startTime: String) {
        self.name = name
        self.startDate = startDate
        self.startTime = startTime
    }
    
}

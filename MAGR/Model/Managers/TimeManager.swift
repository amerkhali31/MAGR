//
//  TimeManager.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation

/**
 This class is responsible for all operations involving processing Dates and Times.
 */
class TimeManager {
    
    /// Takes a time string in military time and returns it as AM/PM time
    static func convert24HrTimeTo12HrTime(_ time: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let time12hr = formatter.date(from: time) else {return "00:99 PM"}
        
        formatter.dateFormat = "h:mm a"
        let newTime = formatter.string(from: time12hr)
        
        return newTime
    }
    
    /// Return the number of the month of the adhan's currently saved to Core Data
    static func getMonthofAdhan(_ monthlyList: [MonthlyPrayerEntity]) -> String {
        return String(monthlyList[0].date!.split(separator: "-")[1])
    }
    
    /// Return the number of the current month in real time as a string
    static func getCurrentMonth() -> String {
        return String(Calendar.current.component(.month, from: Date()))
    }
    
    private init() {}
}

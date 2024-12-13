//
//  PrayerManager.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation

/**
 This class will be responsible for all operations involving processing and manipulating prayer times.
 */
class PrayerManager {
    
    /**
     Checks DataManager.MonthlyPrayerEntities for today's adhan times to be used in today prayers in DataManager
     - Returns:List of Strings representing Adhan times from today's date in the MonthlyPrayerEntities
     */
    static func getTodaysAdhanTimes() -> [String] {
        
        var todayAdhanTimes: [String] = ["","","","",""]
        
        if let todayPrayerTimesElement = DataManager.getMonthlyPrayerEntities().first(where: {$0.date == DataManager.getTodaysDate()}) {
            
            todayAdhanTimes[0] = TimeManager.convert24HrTimeTo12HrTime(todayPrayerTimesElement.fajr!)
            todayAdhanTimes[1] = TimeManager.convert24HrTimeTo12HrTime(todayPrayerTimesElement.dhuhr!)
            todayAdhanTimes[2] = TimeManager.convert24HrTimeTo12HrTime(todayPrayerTimesElement.asr!)
            todayAdhanTimes[3] = TimeManager.convert24HrTimeTo12HrTime(todayPrayerTimesElement.maghrib!)
            todayAdhanTimes[4] = TimeManager.convert24HrTimeTo12HrTime(todayPrayerTimesElement.isha!)
            
        } else {print("Failed to compare times")}
        print("Today's Date: \(DataManager.getTodaysDate())")
        return todayAdhanTimes
    }
    
    /**
     Will check if a prayer's iqama is an actual time or a function of its adhan and return the iqama as a String in actual time
     - Returns: String representing the actual time of the Iqama
     - Parameters:
        - prayer: ``DailyPrayer`` that needs to have it's iqama time checked
     */
    static func processIqama(_ prayer: DailyPrayer) -> String {
            
        if prayer.iqama == "5 minutes after prayer time" {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            
            guard let time = formatter.date(from: prayer.adhan) else {return "00:00 AM"}
               
               let calendar = Calendar.current
               if let newDate = calendar.date(byAdding: .minute, value: 5, to: time) {return formatter.string(from: newDate)}
        }
        
        else {return prayer.iqama}
        
        return "00:00 AM"
    }
    
    
    
    private init() {}
}

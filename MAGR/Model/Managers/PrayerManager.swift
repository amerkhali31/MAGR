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
    
    /// Find the name of the current Prayer
    static func findCurrentPrayer() -> String {
        
        var tempPrayerTimes: [String: Int] = [:]
        
        tempPrayerTimes[K.FireStore.dailyPrayers.names.fajr] = TimeManager.convertTimeToSeconds(DataManager.getFajrToday().adhan)
        tempPrayerTimes[K.FireStore.dailyPrayers.names.dhuhr] = TimeManager.convertTimeToSeconds(DataManager.getDhuhrToday().adhan)
        tempPrayerTimes[K.FireStore.dailyPrayers.names.asr] = TimeManager.convertTimeToSeconds(DataManager.getAsrToday().adhan)
        tempPrayerTimes[K.FireStore.dailyPrayers.names.maghrib] = TimeManager.convertTimeToSeconds(DataManager.getMaghribToday().adhan)
        tempPrayerTimes[K.FireStore.dailyPrayers.names.isha] = TimeManager.convertTimeToSeconds(DataManager.getIshaToday().adhan)
        
        let currentTime = TimeManager.getCurrentTimeAsSecondsFromMidnight()
        
        if currentTime > tempPrayerTimes[K.FireStore.dailyPrayers.names.isha]! || currentTime < tempPrayerTimes[K.FireStore.dailyPrayers.names.fajr]! {return K.FireStore.dailyPrayers.names.isha}
        else if currentTime > tempPrayerTimes[K.FireStore.dailyPrayers.names.maghrib]! {
            return K.FireStore.dailyPrayers.names.maghrib}
        else if currentTime > tempPrayerTimes[K.FireStore.dailyPrayers.names.asr]! {
            return K.FireStore.dailyPrayers.names.asr}
        else if currentTime > tempPrayerTimes[K.FireStore.dailyPrayers.names.dhuhr]! {
            return K.FireStore.dailyPrayers.names.dhuhr}
        else {return K.FireStore.dailyPrayers.names.fajr}

    }
    
    /// Find the name of the next Prayer
    static func getNextPrayer(_ currentPrayer: String) -> String {
        
        switch currentPrayer {
            
        case "Fajr": return"Dhuhr"
        case "Dhuhr": return "Asr"
        case "Asr": return "Maghrib"
        case "Maghrib": return "Isha"
        case "Isha": return "Fajr"
        default: return "No Prayer"
            
        }
        
    }
    
    private init() {}
}

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

    /// Find the name of the current Prayer
    static func findCurrentPrayer() -> DailyPrayer {
        
        var tempPrayerTimes: [String: Int] = [:]
        
        tempPrayerTimes[K.DailyPrayerDisplayNames.fajr] = TimeManager.convertTimeToSeconds(DataManager.fajrToday.adhan)
        tempPrayerTimes[K.DailyPrayerDisplayNames.dhuhr] = TimeManager.convertTimeToSeconds(DataManager.dhuhrToday.adhan)
        tempPrayerTimes[K.DailyPrayerDisplayNames.asr] = TimeManager.convertTimeToSeconds(DataManager.asrToday.adhan)
        tempPrayerTimes[K.DailyPrayerDisplayNames.maghrib] = TimeManager.convertTimeToSeconds(DataManager.maghribToday.adhan)
        tempPrayerTimes[K.DailyPrayerDisplayNames.isha] = TimeManager.convertTimeToSeconds(DataManager.ishaToday.adhan)
        
        let currentTime = TimeManager.getCurrentTimeAsSecondsFromMidnight()
        
        if currentTime > tempPrayerTimes[K.DailyPrayerDisplayNames.isha]!
            || currentTime < tempPrayerTimes[K.DailyPrayerDisplayNames.fajr]! {
            return DataManager.ishaToday
        }
        
        else if currentTime > tempPrayerTimes[K.DailyPrayerDisplayNames.maghrib]! {
            return DataManager.maghribToday
        }
        
        else if currentTime > tempPrayerTimes[K.DailyPrayerDisplayNames.asr]! {
            return DataManager.asrToday
        }
        
        else if currentTime > tempPrayerTimes[K.DailyPrayerDisplayNames.dhuhr]! {
            return DataManager.dhuhrToday
        }
        
        else {return DataManager.fajrToday}

    }
    
    /// Find the name of the next Prayer
    static func getNextPrayer() -> DailyPrayer {
        
        switch DataManager.currentPrayer.name {
            
        case K.DailyPrayerDisplayNames.fajr: return DataManager.dhuhrToday
        case K.DailyPrayerDisplayNames.dhuhr: return DataManager.asrToday
        case K.DailyPrayerDisplayNames.asr: return DataManager.maghribToday
        case K.DailyPrayerDisplayNames.maghrib: return DataManager.ishaToday
        case K.DailyPrayerDisplayNames.isha: return DataManager.fajrToday
        default: return DataManager.fajrToday
            
        }
        
    }
    
    /// Get time until next prayer in seconds
    static func getTimeUntilNextPrayer()  -> Int {
        
        let currentPrayer = DataManager.currentPrayer
        let nextPrayer = DataManager.nextPrayer
        
        if currentPrayer.name == "Isha" &&
            TimeManager.getCurrentTimeAsSecondsFromMidnight() > TimeManager.convertTimeToSeconds(nextPrayer.adhan) {
            return TimeManager.convertTimeToSeconds(nextPrayer.adhan) + ((24 * 3600) - TimeManager.getCurrentTimeAsSecondsFromMidnight())
        }
        else {
            return TimeManager.convertTimeToSeconds(nextPrayer.adhan) - TimeManager.getCurrentTimeAsSecondsFromMidnight()
        }
    }
    
    private init() {}
}

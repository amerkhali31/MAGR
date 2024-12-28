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
        
        tempPrayerTimes[K.FireStore.dailyPrayers.names.fajr] = TimeManager.convertTimeToSeconds(DataManager.getFajrToday().adhan)
        tempPrayerTimes[K.FireStore.dailyPrayers.names.dhuhr] = TimeManager.convertTimeToSeconds(DataManager.getDhuhrToday().adhan)
        tempPrayerTimes[K.FireStore.dailyPrayers.names.asr] = TimeManager.convertTimeToSeconds(DataManager.getAsrToday().adhan)
        tempPrayerTimes[K.FireStore.dailyPrayers.names.maghrib] = TimeManager.convertTimeToSeconds(DataManager.getMaghribToday().adhan)
        tempPrayerTimes[K.FireStore.dailyPrayers.names.isha] = TimeManager.convertTimeToSeconds(DataManager.getIshaToday().adhan)
        
        let currentTime = TimeManager.getCurrentTimeAsSecondsFromMidnight()
        
        if currentTime > tempPrayerTimes[K.FireStore.dailyPrayers.names.isha]! 
            || currentTime < tempPrayerTimes[K.FireStore.dailyPrayers.names.fajr]! {
            return DataManager.getIshaToday()}
        else if currentTime > tempPrayerTimes[K.FireStore.dailyPrayers.names.maghrib]! {
            return DataManager.getMaghribToday()}
        else if currentTime > tempPrayerTimes[K.FireStore.dailyPrayers.names.asr]! {
            return DataManager.getAsrToday()}
        else if currentTime > tempPrayerTimes[K.FireStore.dailyPrayers.names.dhuhr]! {
            return DataManager.getDhuhrToday()}
        else {return DataManager.getFajrToday()}

    }
    
    /// Find the name of the next Prayer
    static func getNextPrayer() -> DailyPrayer {
        
        switch DataManager.getCurrentPrayer().name {
            
        case K.FireStore.dailyPrayers.names.fajr: return DataManager.getDhuhrToday()
        case K.FireStore.dailyPrayers.names.dhuhr: return DataManager.getAsrToday()
        case K.FireStore.dailyPrayers.names.asr: return DataManager.getMaghribToday()
        case K.FireStore.dailyPrayers.names.maghrib: return DataManager.getIshaToday()
        case K.FireStore.dailyPrayers.names.isha: return DataManager.getFajrToday()
        default: return DataManager.getFajrToday()
            
        }
        
    }
    
    /// Get time until next prayer in seconds
    static func getTimeUntilNextPrayer()  -> Int {
        
        let currentPrayer = DataManager.getCurrentPrayer()
        let nextPrayer = DataManager.getNextPrayer()
        
        if currentPrayer.name == "Isha" &&
            TimeManager.getCurrentTimeAsSecondsFromMidnight() > TimeManager.convertTimeToSeconds(nextPrayer.adhan) {
            return TimeManager.convertTimeToSeconds(nextPrayer.adhan) + ((24 * 3600) - TimeManager.getCurrentTimeAsSecondsFromMidnight())
        }
        else {
            return TimeManager.convertTimeToSeconds(DataManager.getNextPrayer().adhan) - TimeManager.getCurrentTimeAsSecondsFromMidnight()
        }
    }
    
    private init() {}
}

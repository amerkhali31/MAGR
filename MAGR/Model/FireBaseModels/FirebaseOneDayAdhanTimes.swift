//
//  FirebaseOneDayAdhanTimes.swift
//  MAGR
//
//  Created by Amer Khalil on 12/27/24.
//

import Foundation

/**
 The basic structure of how one full day worth of adhan times is stored in a document of the Monthly-adhan-times Collection in Firebase
 
 - Note: All times are in 24 hr time and will need to be converted for displaying in the app
 - Note: Default times to 66:66 AM if error
 */
struct FirebaseOneDayAdhanTimes: Codable {
    
    var fajr: String
    var dhuhr: String
    var asr: String
    var maghrib: String
    var isha: String
    var sunrise: String
    var date: String
    
    init(fajr: String = "66:66 AM",
         dhuhr: String = "66:66 AM",
         asr: String = "66:66 AM",
         maghrib: String = "66:66 AM",
         isha: String = "66:66 AM",
         sunrise: String = "66:66 AM",
         date: String = "2024-11-09") {
        self.fajr = fajr
        self.dhuhr = dhuhr
        self.asr = asr
        self.maghrib = maghrib
        self.isha = isha
        self.sunrise = sunrise
        self.date = date
    }
}

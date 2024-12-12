//
//  FirebaseMonthlyPrayer.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation


/**
 The basic structure that all adhans times for a single day of prayers is stored as in Firebase. Defaults times to 00:00 AM and date to 9999-12-31
 
 - Note: Convert whatever comes from announcements Firebase collection to a FirebaseAnnouncement object to be used in the app.
 - Note: One FirebaseMonthlyPrayer Object contains one full day of adhans and the respective date. So app should have a list of 28-31 of these stored for current month.
 - Parameters:
    - fajr: String representing the adhan time of fajr salah for that date
    - zuhr: String representing the adhan time of fajr dhuhr for that date. Named zuhr because thats how magr does it.
    - asr: String representing the adhan time of fajr asr for that date
    - maghrib: String representing the adhan time of maghrib salah for that date
    - date: String representing the date for the attached adhans
 - Important: Similar structure to AnnouncementEntity but not the same thing. Need to create that seperately.
 */
struct FirebaseMonthlyPrayer {
    
    var fajr: String
    var zuhr: String
    var asr: String
    var maghrib: String
    var isha: String
    
    var date: String
    
    init(fajr: String = "00:00 AM",
         zuhr: String = "00:00 AM",
         asr: String = "00:00 AM",
         maghrib: String = "00:00 AM",
         isha: String = "00:00 AM",
         date: String = "9999-12-31") {
        
        self.fajr = fajr
        self.zuhr = zuhr
        self.asr = asr
        self.maghrib = maghrib
        self.isha = isha
        self.date = date
    }
}

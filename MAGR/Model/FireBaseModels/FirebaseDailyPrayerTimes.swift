//
//  FirebaseDailyPrayerTimes.swift
//  MAGR
//
//  Created by Amer Khalil on 12/27/24.
//

import Foundation

/**
 The basic structure of how one full day worth of prayer times (both adhan and iqama) are stored in Firebase
 
 - Note: All times are in 24 hr time and will need to be converted for displaying in the app
 - Note: Also stores jumaa times
 - Note: Default times to 66:66 AM if error
 */
struct FirebaseDailyPrayerTimes: Codable {
    
    var fajr_adhan: String
    var fajr_iqama: String
    var dhuhr_adhan: String
    var dhuhr_iqama: String
    var asr_adhan: String
    var asr_iqama: String
    var maghrib_adhan: String
    var maghrib_iqama: String
    var isha_adhan: String
    var isha_iqama: String
    var jumaa_khutba: String
    var jumaa_salah: String
    
    init(fajr_adhan: String = "66:66 AM",
         fajr_iqama: String = "66:66 AM",
         dhuhr_adhan: String = "66:66 AM",
         dhuhr_iqama: String = "66:66 AM",
         asr_adhan: String = "66:66 AM",
         asr_iqama: String = "66:66 AM",
         maghrib_adhan: String = "66:66 AM",
         maghrib_iqama: String = "66:66 AM",
         isha_adhan: String = "66:66 AM",
         isha_iqama: String = "66:66 AM",
         jumaa_khutba: String = "66:66 AM",
         jumaa_salah: String = "66:66 AM") {
        
        self.fajr_adhan = fajr_adhan
        self.fajr_iqama = fajr_iqama
        self.dhuhr_adhan = dhuhr_adhan
        self.dhuhr_iqama = dhuhr_iqama
        self.asr_adhan = asr_adhan
        self.asr_iqama = asr_iqama
        self.maghrib_adhan = maghrib_adhan
        self.maghrib_iqama = maghrib_iqama
        self.isha_adhan = isha_adhan
        self.isha_iqama = isha_iqama
        self.jumaa_khutba = jumaa_khutba
        self.jumaa_salah = jumaa_salah
    }
    
}

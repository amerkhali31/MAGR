//
//  FirebaseUserPreference.swift
//  MAGR
//
//  Created by Amer Khalil on 12/24/24.
//

import Foundation

/**
 The basic structure defining how a single user is stored in Firebase. Just storing device token and prayer notification preferences
 
 - Note: Separate notification for adhan and iqama for each prayer
 - Parameters:
    - device_token: String Representing the unique identifier of the device to be used for push notification.
    - adhan_iqama: Boolean representing whether the user wants to be notified of that particular event.
 */
struct FirebaseUserPreference {
    
     var fajr_adhan: Bool
     var fajr_iqama: Bool
     var dhuhr_adhan: Bool
     var dhuhr_iqama: Bool
     var asr_adhan: Bool
     var asr_iqama: Bool
     var maghrib_adhan: Bool
     var maghrib_iqama: Bool
     var isha_adhan: Bool
     var isha_iqama: Bool
    var jumaa1_notice: Bool
    var device_token: String
    
    init(fajr_adhan: Bool = false, fajr_iqama: Bool = false,
         dhuhr_adhan: Bool = false, dhuhr_iqama: Bool = false,
         asr_adhan: Bool = false, asr_iqama: Bool = false,
         maghrib_adhan: Bool = false, maghrib_iqama: Bool = false,
         isha_adhan: Bool = false, isha_iqama: Bool = false,
         jumaa1_notice: Bool = false, device_token: String) {
        
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
        self.jumaa1_notice = jumaa1_notice
        self.device_token = device_token
    }
    
}

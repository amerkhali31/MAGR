//
//  FirebasePrayer.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation


/**
 The basic structure that a single daily prayer is stored as in Firebase. Default Times to 99:99 AM and name to N/A.
 
 - Note: Convert whatever comes from daily prayers Firebase collection to a FirebasePrayer object to be used in the app.
 - Note: Firebase currently ony stores name of the prayer and it's iqama time as "name" and "time" fields. Will probably be updated in the future.
 - Note: Each of the 5 daily prayers as well as Jumaa Salah and Khutbah each have their own document in the dailyprayers collection which gets updated everyday at midnight by crontab.
 - Important: Similar structure to DailyPrayerEntity but not the same thing. Need to create that seperately.
 */
struct FirebasePrayer {
    
    var name: String
    var iqama: String
    var adhan: String
    
    init(_ name: String = "N/A", _ iqama: String = "99:99 AM", _ adhan: String = "99:99 AM") {
        
        self.name = name
        self.iqama = iqama
        self.adhan = adhan
    }
}

//
//  FirebasePrayer.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation


/**
 The basic structure that a single daily prayer is stored as in Firebase. Default time 99:99 AM and name  N/A.
 
 - Note: Convert whatever comes from daily prayers Firebase collection to a FirebasePrayer object to be used in the app.
 - Note: Firebase currently ony stores name of the prayer and it's iqama time as "name" and "time" fields. Will probably be updated in the future.
 - Note: Each of the 5 daily prayers as well as Jumaa Salah and Khutbah each have their own document in the dailyprayers collection which gets updated everyday at midnight by crontab.
 - Parameters:
    - name: Name of the prayer that was fetched from firebase
    - iqama: Time of the iqama fetched from firebase
 - Important: Similar structure to DailyPrayerEntity but not the same thing. Need to create that seperately.
 */
struct FirebasePrayer {
    
    var name: String
    var time: String
    
    init(_ name: String = "N/A", _ time: String = "99:99 AM") {
        
        self.name = name
        self.time = time
    }
}

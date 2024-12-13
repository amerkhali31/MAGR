//
//  Constants.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation

///Stores strings reprenting names that should not change. Used to avoid accidental misspelling of an important name.
struct K {
    
    ///Stores the name of the custom TableView Cells created - both NibNames and ReuseIdentifiers
    struct TableViewCells {
        
        struct ReuseIdentifiers {
            
            static let mPrayer = "MonthlyPrayerCell"
        }
        
        struct NibNames {
            static let mPrayer = "MonthlyPrayerCell"
        }
    }
    
    ///Stores the names of all items found in Firebase
    struct FireStore {
        
        /// Names of the different Collections being stored in Firebase
        struct Collections {
            
            static let prayer_times = "daily_prayer_times"
            static let announcements = "announcements"
            static let monthly_prayer_times = "adhan_prayer_times"
            
        }
        
        /// The names associated with a doc stored in the dailyPrayers Collection in firebase
        struct dailyPrayers {
            
            /// The names of the fields saved in the doc
            struct fields {
                
                static let name = "name"
                static let time = "time"
            }
            
            /// The exact spelling of the different possible names as they are saved in the name field of the doc in the dailyPrayers Collection
            struct names {
                
                static let fajr = "Fajr"
                static let dhuhr = "Zuhr"
                static let asr = "Asr"
                static let maghrib = "Maghrib"
                static let isha = "Isha"
                static let jumaaKhutba = "Friday Khutbah"
                static let jumaaSalah = "Friday Salat"
            }
            
        }
        
        /// The names of the fields stored in a single document of the monthlyPrayers Collection in firebase
        struct monthlyPrayers {
            
            static let fajr = "fajr"
            static let zuhr = "zuhr"
            static let asr = "asr"
            static let maghrib = "maghrib"
            static let isha = "isha"
            static let date = "date"
        }
        
        /// The names of the fields stored in a single document of the announcement Collection in firebase
        struct announcement {
            
            static let url = "url"
        }
    }
    
    ///Store the names given to each notification so they can later be referenced for deletion and scheduling.
    struct AdhanNotifications {
        static let fajrNotice = "Fajr"
        static let dhuhrNotice = "Zuhr"
        static let asrNotice = "Asr"
        static let maghribNotice = "Maghrib"
        static let ishaNotice = "Isha"
    }
    
    /// Segue Names
    struct segues {
        
        static let loadSeque = "loaded"
    }
    
    /// Names of different values stored in UserDefaults
    struct userDefaults {
        
        static let lastNetworkDate = "dateOfLastNetwork"
        static let userWantsNotitifications = "userWantsNotifications"
        static let fajrNotice = "fn"
        static let dhuhrNotice = "dn"
        static let asrNotice = "an"
        static let maghribNotice = "mn"
        static let ishaNotice = "in"
    }
    
    /// Names of images saved to assets
    struct images {
        static let logo = "magrImage"
    }
}

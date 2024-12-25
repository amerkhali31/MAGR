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
            static let hadiths = "hadiths"
            
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
        
        /// The name of the field stored in the one document in the hadiths Collection in firebase
        struct hadiths {
            static let number = "number"
        }
        
        /// The names of the fields stored in a single document of the user preference Collection in firebase
        struct Notifications {
            static let fajr_adhan = "fajr_adhan"
            static let fajr_iqama = "fajr_iqama"
            static let dhuhr_adhan = "dhuhr_adhan"
            static let dhuhr_iqama = "dhuhr_iqama"
            static let asr_adhan = "asr_adhan"
            static let asr_iqama = "asr_iqama"
            static let maghrib_adhan = "maghrib_adhan"
            static let maghrib_iqama = "maghrib_iqama"
            static let isha_adhan = "isha_adhan"
            static let isha_iqama = "isha_iqama"
            static let jumaa1_notice = "jumaa1_notice"
            static let device_token = "device_token"
        }
    }
    
    ///Store the names given to each notification so they can later be referenced for deletion and scheduling.
    /// - IMPORTANT: NEEDS TO REMAIN COUPLED WITH Firestore.dailyprayers.names
    struct AdhanNotifications {
        static let fajrNotice = FireStore.dailyPrayers.names.fajr
        static let dhuhrNotice = FireStore.dailyPrayers.names.dhuhr
        static let asrNotice = FireStore.dailyPrayers.names.asr
        static let maghribNotice = FireStore.dailyPrayers.names.maghrib
        static let ishaNotice = FireStore.dailyPrayers.names.isha
    }
    
    /// Segue Names
    struct segues {
        
        static let loadSeque = "loaded"
        static let announceSegue = "Announcements"
    }
    
    /// Names of different values stored in UserDefaults
    struct userDefaults {
        
        static let lastNetworkDate = "dateOfLastNetwork"
        static let userWantsNotitifications = "userWantsNotifications"
        
        static let fajr_adhan_notification = "fan"
        static let dhuhr_adhan_notification = "dan"
        static let asr_adhan_notification = "aan"
        static let maghrib_adhan_notification = "man"
        static let isha_adhan_notification = "ian"
        
        static let fajr_iqama_notification = "fin"
        static let dhuhr_iqama_notification = "din"
        static let asr_iqama_notification = "ain"
        static let maghrib_iqama_notification = "min"
        static let isha_iqama_notification = "iin"
        
        static let pushNoticeTest = "pushTest"
        static let hadithNumber = "hadithNumber"
    }
    
    /// Names of images saved to assets
    struct images {
        static let logo = "magrImage"
        static let mosque = "magr_mosque"
    }
    
}


//
//  Constants.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation

///Stores strings reprenting names that should not change. Used to avoid accidental misspelling of an important name.
struct K {
    
    ///Stores the names of all items found in Firebase
    struct FireStore {
        
        /// Names of the different Collections being stored in Firebase
        struct Collections {
            
            // Current Collections
            /**
             The naming structure of how the Monthly monthly-adhan-times Collection is stored in Firebase
             - Note: Document ID's Dynamically set to Date in yyyy-MM-dd format
             */
            struct monthly_adhan_times {
                static let collection_name = "monthly_adhan_times"
                
                /**
                 The names of the individual fields found in a single document in the monthly-adhan-times Collection in Firebase
                 - Note: Each field has a string associated with it that is a 24 hr time that represents the adhan of the respective prayer
                 */
                struct fields {
                    static let fajr = "fajr"
                    static let dhuhr = "dhuhr"
                    static let asr = "asr"
                    static let maghrib = "maghrib"
                    static let isha = "isha"
                    static let sunrise = "sunrise"
                }
            }
            
            
            /// The naming structure of how the todays-prayer-times Collection is stored in Firebase
            struct todays_prayer_times {
                static let collection_name = "todays_prayer_times"
                
                
                /// The name of the individual document found in the monthly-adhan-times Collection in Firebase
                struct daily_prayer_times {
                    static let document_name = "daily_prayer_times"
                    
                    /**
                     The names of the individual fields found in the daily-prayer-times document in the today-prayer-times Collection in Firebase
                     - Note: Each field has a string associated with it that is a 24 hr time that represents the adhan or iqama of the respective prayer
                     */
                    struct fields {
                        static let fajr_adhan = "fajr_adhan"
                        static let fajr_iqama = "fajr_iqama"
                        static let dhuhr_adhan = "dhuhr_adhan"
                        static let dhuhr_iqama = "asr_iqama"
                        static let asr_adhan = "asr_adhan"
                        static let asr_iqama = "asr_iqama"
                        static let maghrib_adhan = "maghrib_adhan"
                        static let maghrib_iqama = "maghrib_iqama"
                        static let isha_adhan = "isha_adhan"
                        static let isha_iqama = "isha_iqama"
                        static let jumaa_khutba = "jumaa_khutba"
                        static let jumaa_salah = "jumaa_salah"
                    }
                    
                }
            }
            
            
            /// The naming structure of how the hadiths Collection is stored in Firebase
            struct hadiths {
                static let collection_name = "hadiths"
                
                /// The name of the single document found in the hadiths Collection in Firebase
                struct hadith {
                    static let document_name = "hadith"
                    
                    /**
                     The name of the field found in the hadith document of the hadiths Collection in Firebase
                     - Note: The number field stores a string that represents an int to be passed to the hadiths api for the hadith number
                     */
                    struct fields {
                        static let number = "number"
                    }
                }
            }
            
            
            /// The naming structure of how the announcements Collection is stored in Firebase
            struct announcements {
                static let collection_name = "announcements"
                
                /// The name of the single document found in the announcements Collection in Firebase
                struct announcements {
                    static let document_name = "announcements"
                    
                    /**
                     The name of the field found in the announcements document of the announcements Collection in Firebase
                     - Note: The urls field is a list of strings that represent the url's to the announcement images from the MAGR website
                     */
                    struct fields {
                        static let urls = "urls"
                    }
                }
            }
            
        }
        
    }
    
    /// The names of the prayers as they are to be displayed throughout the app and saved to DataManager.dailyPrayers
    struct DailyPrayerDisplayNames {
        static let fajr = "Fajr"
        static let dhuhr = "Dhuhr"
        static let asr = "Asr"
        static let maghrib = "Maghrib"
        static let isha = "Isha"
        static let jumaa_salah = "Jumaa Salah"
        static let jumaa_khutba = "Jumaa Khutba"
    }
    
    /// Segue Names
    struct segues {
        
        static let loadSeque = "loaded"
        static let announceSegue = "Announcements"
    }
    
    /// Names of different values stored in UserDefaults
    /// - Important: leave all notifications = firestore notification names to remain consistent. Keep coupled or will no longer access firestore properly.
    struct userDefaults {
        
        static let lastNetworkDate = "dateOfLastNetwork"
        static let userWantsNotitifications = "userWantsNotifications"
        
        static let fajr_adhan_notification = "fajr_adhan"
        static let dhuhr_adhan_notification = "dhuhr_adhan"
        static let asr_adhan_notification = "asr_adhan"
        static let maghrib_adhan_notification = "maghrib_adhan"
        static let isha_adhan_notification = "isha_adhan"
        
        static let fajr_iqama_notification = "fajr_iqama"
        static let dhuhr_iqama_notification = "dhuhr_iqama"
        static let asr_iqama_notification = "asr_iqama"
        static let maghrib_iqama_notification = "maghrib_iqama"
        static let isha_iqama_notification = "isha_iqama"
        
        static let pushNoticeTest = "pushTest"
        static let hadithNumber = "hadithNumber"
    }
    
    /// Names of images saved to assets
    struct images {
        static let logo = "magrImage"
        static let mosque = "magr_mosque"
    }
    
}


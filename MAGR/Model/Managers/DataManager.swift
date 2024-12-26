//
//  DataManager.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation
import CoreData
import UIKit

/**
 This class will be responsible for hosting all data and data operations for the entire app.
 
 - Note: Primary functions are loading from Persistent Storage, saving to Persistent Storage, keeping track of networked data and distributing it throughout app
 */
class DataManager {
    
    // MARK: Setting up UserDefaults
    private static let defaults = UserDefaults.standard
    private static var dateOfLastNetwork = Date()
    private static var userWantsNotifications = false
    private static var hadithNumber = "1"
    static let notices = [
        K.userDefaults.fajr_adhan_notification,
        K.userDefaults.fajr_iqama_notification,
        K.userDefaults.dhuhr_adhan_notification,
        K.userDefaults.dhuhr_iqama_notification,
        K.userDefaults.asr_adhan_notification,
        K.userDefaults.asr_iqama_notification,
        K.userDefaults.maghrib_adhan_notification,
        K.userDefaults.maghrib_iqama_notification,
        K.userDefaults.isha_adhan_notification,
        K.userDefaults.isha_iqama_notification,
    ]
    static var gotPushNoticeCounter: Int = 0
    static var prayer_notification_preferences: [String: Bool] = [:]
    
    // MARK: Setting Up Persistent Storage
    private static let persistentContianer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var NotificationEntities: [String : NotificationEntity] = [:]
    private static var DailyPrayerEntities: [String: DailyPrayerEntity] = [:]
    private static var MonthlyPrayerEntities: [MonthlyPrayerEntity] = []
    
    // MARK: Announcements
    private static var urlList: [URL] = []
    private static var urlImages: [UIImage] = []
    
    // MARK: Date
    private static var todaysDate: String = ""
    
    // MARK: Prayers
    private static var currentPrayer: DailyPrayer = DailyPrayer()
    private static var nextPrayer: DailyPrayer = DailyPrayer()
    
    private static var fajrToday: DailyPrayer = DailyPrayer(name: K.FireStore.dailyPrayers.names.fajr)
    private static var dhuhrToday: DailyPrayer = DailyPrayer(name: K.FireStore.dailyPrayers.names.dhuhr)
    private static var asrToday: DailyPrayer = DailyPrayer(name: K.FireStore.dailyPrayers.names.asr)
    private static var maghribToday: DailyPrayer = DailyPrayer(name: K.FireStore.dailyPrayers.names.maghrib)
    private static var ishaToday: DailyPrayer = DailyPrayer(name: K.FireStore.dailyPrayers.names.isha)
    
    private static var khutbaToday: DailyPrayer = DailyPrayer(name: K.FireStore.dailyPrayers.names.jumaaKhutba)
    private static var jumaaToday: DailyPrayer = DailyPrayer(name: K.FireStore.dailyPrayers.names.jumaaSalah)
    
    private static var monthlyPrayers: [FirebaseMonthlyPrayer] = []
    
    // MARK: Notifications
    static var device_token: String = ""
    static var notificationPreferences = FirebaseUserPreference(device_token: device_token)
    
    private init() {}
}

// MARK: Data Manager Operations - GET
extension DataManager {
    
    /// Grab urlList List of URLs from DataManager
    static func getUrlList() -> [URL] {return urlList}
    
    /// Grab urlList List of Images from DataManager
    static func getUrlImages() -> [UIImage] {return urlImages}
    
    /// Grab todaysDate String from DataManager
    static func getTodaysDate() -> String {return todaysDate}
    
    /// Grab CurrentPrayer ``DailyPrayer`` from DataManager
    static func getCurrentPrayer() -> DailyPrayer {return currentPrayer}
    
    /// Grab CurrentPrayer ``DailyPrayer`` from DataManager
    static func getNextPrayer() -> DailyPrayer {return nextPrayer}
    
    /// Grab ``DailyPrayer`` for adhan and iqama associated with Fajr Today
    static func getFajrToday() -> DailyPrayer {return fajrToday}
    
    /// Grab ``DailyPrayer`` for adhan and iqama associated with Dhuhr Today
    static func getDhuhrToday() -> DailyPrayer {return dhuhrToday}
    
    /// Grab ``DailyPrayer`` for adhan and iqama associated with Asr Today
    static func getAsrToday() -> DailyPrayer {return asrToday}
    
    /// Grab ``DailyPrayer`` for adhan and iqama associated with Maghrib Today
    static func getMaghribToday() -> DailyPrayer {return maghribToday}
    
    /// Grab ``DailyPrayer`` for adhan and iqama associated with Isha Today
    static func getIshaToday() -> DailyPrayer {return ishaToday}
    
    /// Grab ``DailyPrayer`` for adhan and iqama associated with Jumaa Khutba
    static func getKhutba() -> DailyPrayer {return khutbaToday}
    
    /// Grab ``DailyPrayer`` for adhan and iqama associated with Jumaa Salah
    static func getJumaa() -> DailyPrayer {return jumaaToday}
    
    /// Grab ``FirebaseMonthlyPrayer`` list  for all adhans for the month
    static func getMonthlyTimes() -> [FirebaseMonthlyPrayer] {return monthlyPrayers}
    
    /// Grab MonthlyPrayerEntites from DataManager to be used elsewhere in the app
    static func getMonthlyPrayerEntities() -> [MonthlyPrayerEntity] {return MonthlyPrayerEntities}
}

// MARK: Data Manager Operations - SET
extension DataManager {
    
    /// Set the value for urlList List of URLs from DataManager from given list of urls
    static func setUrlList(_ urls: [URL]) {urlList = urls}
    
    /// Set the value for urlList List of Images from DataManager from given list of images
    static func setUrlImages(_ images: [UIImage]) {urlImages = images}
    
    /// Set the value for todaysDate String from DataManager from given date string
    static func setTodaysDate(_ date: String) {todaysDate = date}
    
    /// Set the value for CurrentPrayer ``DailyPrayer`` from DataManager from given DailyPrayer
    static func setCurrentPrayer(_ prayer: DailyPrayer) {currentPrayer = prayer}
    
    /// Set the value for CurrentPrayer ``DailyPrayer`` from DataManager from given DailyPrayer
    static func setNextPrayer(_ prayer: DailyPrayer) {nextPrayer = prayer}
    
    /// Set the value for ``DailyPrayer`` for adhan and iqama associated with Fajr Today from given DailyPrayer
    static func setFajrToday(_ prayer: DailyPrayer) {fajrToday = prayer}
    
    /// Set the value for ``DailyPrayer`` for adhan and iqama associated with Dhuhr Today from given DailyPrayer
    static func setDhuhrToday(_ prayer: DailyPrayer) {dhuhrToday = prayer}
    
    /// Set the value for ``DailyPrayer`` for adhan and iqama associated with Asr Today from given DailyPrayer
    static func setAsrToday(_ prayer: DailyPrayer) {asrToday = prayer}
    
    /// Set the value for ``DailyPrayer`` for adhan and iqama associated with Maghrib Today from given DailyPrayer
    static func setMaghribToday(_ prayer: DailyPrayer) {maghribToday = prayer}
    
    /// Set the value for ``DailyPrayer`` for adhan and iqama associated with Isha Today from given DailyPrayer
    static func setIshaToday(_ prayer: DailyPrayer) {ishaToday = prayer}
    
    /// Set the value for ``DailyPrayer`` for adhan and iqama associated with Jumaa Khutba from given DailyPrayer
    static func setKhutba(_ prayer: DailyPrayer) {khutbaToday = prayer}
    
    /// Set the value for ``DailyPrayer`` for adhan and iqama associated with Jumaa Salah from given DailyPrayer
    static func setJumaa(_ prayer: DailyPrayer) {jumaaToday = prayer}
    
    /// Set the value for ``FirebaseMonthlyPrayer`` list  for all adhans for the month from given liar of FirebaseMonthlyPrayers
    static func setMonthlyTimes(_ prayers: [FirebaseMonthlyPrayer]) {monthlyPrayers = prayers}
    
    /// Save the given Hadith Number to UserDefaults and DataManager hadithNumber
    static func setHadithNumber(_ number: String = "1") {
        defaults.set(number, forKey: K.userDefaults.hadithNumber)
        hadithNumber = number
    }
    
    /// Save the given Date to UserDefaults and DataManager dateOfLastNetwork
    static func setDateOfLastNetwork(_ date: Date = Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 9))!) {
        defaults.set(date, forKey: K.userDefaults.lastNetworkDate)
        dateOfLastNetwork = date
    }
    
    /// Save the given Bool to UserDefaults and DataManager UserWantsNotifications
    static func setUserWantsNotifications(_ status: Bool = false) {
        defaults.set(status, forKey: K.userDefaults.userWantsNotitifications)
        userWantsNotifications = status
    }
    
    static func setSingleUserPreference(_ name: String, _ status: Bool) {
        prayer_notification_preferences[name] = status
        defaults.set(prayer_notification_preferences[name], forKey: name)
    }
    
    ///asdf
    static func setUserNotificationPreferences(_ preferences: FirebaseUserPreference) {
        prayer_notification_preferences[K.FireStore.Notifications.fajr_adhan] = preferences.fajr_adhan
        prayer_notification_preferences[K.FireStore.Notifications.fajr_iqama] = preferences.fajr_iqama
        prayer_notification_preferences[K.FireStore.Notifications.dhuhr_adhan] = preferences.dhuhr_adhan
        prayer_notification_preferences[K.FireStore.Notifications.dhuhr_iqama] = preferences.dhuhr_iqama
        prayer_notification_preferences[K.FireStore.Notifications.asr_adhan] = preferences.asr_adhan
        prayer_notification_preferences[K.FireStore.Notifications.asr_iqama] = preferences.asr_iqama
        prayer_notification_preferences[K.FireStore.Notifications.maghrib_adhan] = preferences.maghrib_adhan
        prayer_notification_preferences[K.FireStore.Notifications.maghrib_iqama] = preferences.maghrib_iqama
        prayer_notification_preferences[K.FireStore.Notifications.isha_adhan] = preferences.isha_adhan
        prayer_notification_preferences[K.FireStore.Notifications.isha_iqama] = preferences.isha_iqama
        
        for notice in notices {
            defaults.set(prayer_notification_preferences[notice], forKey: notice)
        }
    }
    
    /// Test
    static func setPushNoticeTest(count: Int = 0) {
        defaults.set(count, forKey: K.userDefaults.pushNoticeTest)
        gotPushNoticeCounter = count
    }
    
}

// MARK: Persistent Storage Operations - CREATE
extension DataManager {
    
    /// Create and return a DailyPrayerEntity from a ``DailyPrayer`` Object
    static func createDailyPrayerEntity(_ prayer: DailyPrayer) -> DailyPrayerEntity {
        
        let dailyPrayerEntity = DailyPrayerEntity(context: DataManager.context)
        dailyPrayerEntity.prayer = prayer.name
        dailyPrayerEntity.iqama = prayer.iqama
        dailyPrayerEntity.adhan = prayer.adhan
        
        return dailyPrayerEntity
    }
    
    /// Create and return a MonthlyPrayerEnttiy from a ``FirebaseMonthlyPrayer`` Object
    static func createMonthlyPrayerEntity(_ prayers: FirebaseMonthlyPrayer) -> MonthlyPrayerEntity {
        
        let monthlyPrayerEntity = MonthlyPrayerEntity(context: context)
        monthlyPrayerEntity.fajr = prayers.fajr
        monthlyPrayerEntity.dhuhr = prayers.zuhr
        monthlyPrayerEntity.asr = prayers.asr
        monthlyPrayerEntity.maghrib = prayers.maghrib
        monthlyPrayerEntity.isha = prayers.isha
        monthlyPrayerEntity.date = prayers.date
        
        return monthlyPrayerEntity
    }
    
    /// Create and return a NotificationEntity from a Prayer Name and a Notification Status
    static func createNotificationEntity(_ prayer: String, _ status: Bool = false) -> NotificationEntity {
        
        let notificationEntity = NotificationEntity(context: context)
        notificationEntity.prayer = prayer
        notificationEntity.status = status
        
        return notificationEntity
    }
    
}

// MARK: Persistent Storage Operations - READ
extension DataManager {
    
    /// Test
    static func getPushNotificationCount() -> Int {
        if let count = defaults.object(forKey: K.userDefaults.pushNoticeTest) as? Int {gotPushNoticeCounter = count}
        else {setPushNoticeTest()}
        return gotPushNoticeCounter
    }

    
    /// Grab dateOfLastNetwork from UserDefaults and create it if it doesnt exist. Then assign it to DataManager.dateOfLastNetwork
    /// Come back to this and verify that this is actually what you want
    static func getDateofLastNetwork() -> Date {
        
        if let day = defaults.object(forKey: K.userDefaults.lastNetworkDate) as? Date {dateOfLastNetwork = day}
        else {setDateOfLastNetwork()}
        return dateOfLastNetwork
    }
    
    /// Load user notification preferences from user defaults and set prayerNotificationPrefences accordingly. creates values if they dont exist already.
    static func loadUserNotificationPreferences() {
        for notice in notices {
            
            if let noticeStatus = defaults.object(forKey: notice) as? Bool {prayer_notification_preferences[notice] = noticeStatus}
            else {setSingleUserPreference(notice, false)}
        }
    }
    
    /// Grab userWantsNotifications Bool from UserDefaults and create it if it doesnt exist. Then assign it to DataManager.userWantsNotifications
    static func getUserWantsNotice() -> Bool {
        
        if let status = defaults.object(forKey: K.userDefaults.userWantsNotitifications) as? Bool {userWantsNotifications = status}
        else {setUserWantsNotifications()}
        return userWantsNotifications
    }
    
    /// Grab hadithNumber String from UserDefaults and create it if it doesnt exist. Then assign it to DataManager.hadithNumber
    static func getHadithNumber() -> String {
        if let number = defaults.object(forKey: K.userDefaults.hadithNumber) as? String {hadithNumber = number}
        else { setHadithNumber() }
        return hadithNumber
    }
    
    /// Grab DailyPrayerEntities from Core Data and populate DataManager DailyPrayerEntities dict
    static func loadDailyPrayerEntities() throws {
        
        let request : NSFetchRequest<DailyPrayerEntity> = DailyPrayerEntity.fetchRequest()
        let dailyPrayerEntities = try context.fetch(request)
        
        for entity in dailyPrayerEntities {
            guard let prayerName = entity.prayer else {continue}
            DailyPrayerEntities[prayerName] = entity
        }
    }
    
    /// Grab MonthlyPrayerEntities from Core Data and populate DataManager MonthlyPrayerEntities list
    static func loadMonthlyPrayerEntities() throws {
        
        let request : NSFetchRequest<MonthlyPrayerEntity> = MonthlyPrayerEntity.fetchRequest()
        let monthlyPrayerEntities = try context.fetch(request)
        
        for entity in monthlyPrayerEntities {
            MonthlyPrayerEntities.append(entity)
        }
        
        MonthlyPrayerEntities.sort {$0.date! < $1.date!}
        
    }
    
    /** Grab NotificationEntities from Core Data and populate DataManager NotificiationEntities dict
     - Note: If empty, create Notification Entities initialized to false for each of the 5 daily prayers using K.firestore.names
     */
    static func loadNotificationEntities() throws {
        
        let request : NSFetchRequest<NotificationEntity> = NotificationEntity.fetchRequest()
        let notificationEntities = try context.fetch(request)
        
        if notificationEntities.count == 0 {
            NotificationEntities[K.FireStore.dailyPrayers.names.fajr] = createNotificationEntity(K.FireStore.dailyPrayers.names.fajr)
            NotificationEntities[K.FireStore.dailyPrayers.names.dhuhr] = createNotificationEntity(K.FireStore.dailyPrayers.names.dhuhr)
            NotificationEntities[K.FireStore.dailyPrayers.names.asr] = createNotificationEntity(K.FireStore.dailyPrayers.names.asr)
            NotificationEntities[K.FireStore.dailyPrayers.names.maghrib] = createNotificationEntity(K.FireStore.dailyPrayers.names.maghrib)
            NotificationEntities[K.FireStore.dailyPrayers.names.isha] = createNotificationEntity(K.FireStore.dailyPrayers.names.isha)
        }
        else {
            for entity in notificationEntities {
                NotificationEntities[entity.prayer!] = entity
            }
        }
    }
    
}

// MARK: Persistent Storage Operations - UPDATE
extension DataManager {
    
    /**
     Clears Monthly Adhans from Core Data and DataManager. And replaces with new values gotten from Firebase
     - Note: Creates list of MonthlyPrayerEntity from list of provided `FirebaseMonthlyPrayer.
     - Note: Adds to DataManager.MonthlyPrayerEntities then saves data
     */
    static func updateMonthlyAdhanStorage(_ prayers: [FirebaseMonthlyPrayer]) {
                
        do {
            
            try clearMonthlyPrayerEntities()
            
            for dailyPrayers in prayers {
                MonthlyPrayerEntities.append(createMonthlyPrayerEntity(dailyPrayers))
            }
            
            MonthlyPrayerEntities.sort {$0.date! < $1.date!}
            
            saveDatabase()
            
        }
        catch {print("Could not clear monthly")}

    }
    
    /**
     Clears Daily Prayer times from Core Data and DataManager and repopulates them with updated values gotten from Firebase
     - Note: This is where Daily Prayers and Jumaa will be committed to memory
     - Important: Only works as intended if Monthly Times are properly loaded and have correct values
     */
    static func updateDailyPrayerStorage(_ prayers: [String : FirebasePrayer]) {
        
        // Make sure there will be no duplicate or conflicting data
        do {
            
            try clearDailyPrayerEntities()
            
            setTodayAdhanTimes()
            
            fajrToday.iqama = prayers[K.FireStore.dailyPrayers.names.fajr]?.time ?? "00:00 AM"
            dhuhrToday.iqama = prayers[K.FireStore.dailyPrayers.names.dhuhr]?.time ?? "00:00 AM"
            asrToday.iqama = prayers[K.FireStore.dailyPrayers.names.asr]?.time ?? "00:00 AM"
            maghribToday.iqama = prayers[K.FireStore.dailyPrayers.names.maghrib]?.time ?? "00:00 AM"
            ishaToday.iqama = prayers[K.FireStore.dailyPrayers.names.isha]?.time ?? "00:00 AM"
            jumaaToday.iqama = prayers[K.FireStore.dailyPrayers.names.jumaaSalah]?.time ?? "00:00 AM"
            khutbaToday.iqama = prayers[K.FireStore.dailyPrayers.names.jumaaKhutba]?.time ?? "00:00 AM"
            
            fajrToday.iqama = PrayerManager.processIqama(fajrToday)
            dhuhrToday.iqama = PrayerManager.processIqama(dhuhrToday)
            asrToday.iqama = PrayerManager.processIqama(asrToday)
            maghribToday.iqama = PrayerManager.processIqama(maghribToday)
            ishaToday.iqama = PrayerManager.processIqama(ishaToday)
            jumaaToday.iqama = PrayerManager.processIqama(jumaaToday)
            khutbaToday.iqama = PrayerManager.processIqama(khutbaToday)
            
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.fajr] = createDailyPrayerEntity(fajrToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.dhuhr] = createDailyPrayerEntity(dhuhrToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.asr] = createDailyPrayerEntity(asrToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.maghrib] = createDailyPrayerEntity(maghribToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.isha] = createDailyPrayerEntity(ishaToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.jumaaSalah] = createDailyPrayerEntity(jumaaToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.jumaaKhutba] = createDailyPrayerEntity(khutbaToday)
            
            saveDatabase()
            
        } catch {print("Could not clear daily")}
        
    }
    
    /// Helper function to set the adhan times from MonthlyPrayerEntities by callling PrayerManager.getTodayAdhan()
    static func setTodayAdhanTimes() {
        let todayAdhanTimes = PrayerManager.getTodaysAdhanTimes()
        fajrToday.adhan = todayAdhanTimes[0]
        dhuhrToday.adhan = todayAdhanTimes[1]
        asrToday.adhan = todayAdhanTimes[2]
        maghribToday.adhan = todayAdhanTimes[3]
        ishaToday.adhan = todayAdhanTimes[4]

    }

    /**
     Handle Monthly Prayer Time Data. Choose between using Core Data values or fetching new values from Firebase
     - Note: If fetching new values, will update monthly prayer times
     */
    static func handleMonthly() async {
            
        if MonthlyPrayerEntities.count == 0 || TimeManager.getCurrentMonth() != TimeManager.getMonthofAdhan(MonthlyPrayerEntities) {
                        
            do {
                let monthlyTimes = try await FirebaseManager.fetchAdhanTimes()
                updateMonthlyAdhanStorage(monthlyTimes)
                
            }
            catch{ print("Error handling Monthly: \(error)") }

        } else {}
    }
    
    
    /**
     Handle Daily Prayer Times. Choose between using Core Data values or fetching new values from Firebase
     - Note: Will always update DataManager TodayAdhan and TodayIqama properties
     */
    static func handleDaily() async {
        
        //Situation where need to network
        if DailyPrayerEntities.count == 0 || !Calendar.current.isDate(dateOfLastNetwork, inSameDayAs: Date()) {
                        
            do {
                
                let iqamaTimes = try await FirebaseManager.fetchIqamaTimes()
                updateDailyPrayerStorage(iqamaTimes)
                
            } catch { print("Error Handling Dailies: \(error)")}
        }
        else {
            //print("HANDLE DAILY ELSE CLOSURE")
//            print("Date of Last Network: \(dateOfLastNetwork)")
//            print("Current Date: \(Date())")
//            print("Check: \(Calendar.current.isDate(dateOfLastNetwork, inSameDayAs: Date()))")
            setTodayAdhanTimes()
            fajrToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.fajr]?.iqama ?? "22:22 AM"
            dhuhrToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.dhuhr]?.iqama ?? "22:22 AM"
            asrToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.asr]?.iqama ?? "22:22 AM"
            maghribToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.maghrib]?.iqama ?? "22:22 AM"
            ishaToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.isha]?.iqama ?? "22:22 AM"
            jumaaToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.jumaaSalah]?.iqama ?? "22:22 AM"
            khutbaToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.jumaaKhutba]?.iqama ?? "22:22 AM"
        }
        
    }
    
    
    /**
     Always network for announcement images. Updates DataManager.`urlList and urlImages
     */
    static func handleAnnouncements() async {
        do {
            
                let stringUrlList = try await FirebaseManager.fetchAnnouncementImageURLs()
                
                for string in stringUrlList {
                    if let safeUrl = URL(string: string) {urlList.append(safeUrl)}
                }
                
                let images = try await FirebaseManager.fetchAnnouncementImages(urlList)

                for image in images {
                    DataManager.urlImages.append(image)
                }
            
            } catch { print("Error during announcement handling: \(error)") }
    }
}

// MARK: Persistent Storage Operations - DELETE
extension DataManager {
    
    static func saveDatabase() {
        do {
            try context.save()
        }
        catch {print("Error saving context: \(error)")}
    }
    
    static func clearCoreData() {
        
        guard let entities = context.persistentStoreCoordinator?.managedObjectModel.entities else {
                print("No entities found in the Core Data model.")
                return
            }
        
        do {
               for entity in entities {
                   
                   guard let entityName = entity.name else { continue }
                   
                   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                   let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                   
                   try context.execute(batchDeleteRequest)
               }
            try context.save()
            print("Successfully cleared all data in Core Data.")
            printAllCoreData(context: context)
            
           } catch {print("Error clearing Core Data: \(error)")}
    }
    
    static func clearMonthlyPrayerEntities() throws {
        
        MonthlyPrayerEntities = []
        
        let request : NSFetchRequest<NSFetchRequestResult> = MonthlyPrayerEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try context.execute(deleteRequest)
        try context.save()
            
        //print("Successfully cleared all MonthlyPrayers from Core Data records.")
    }
    
    static func clearDailyPrayerEntities() throws {
        
        DailyPrayerEntities = [:]

        let request : NSFetchRequest<NSFetchRequestResult> = DailyPrayerEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try context.execute(deleteRequest)
        try context.save()
            
        //print("Successfully cleared all Daily Prayer Core Data records.")
    }
    
    static func clearNotificationEntities() throws {
        
        NotificationEntities = [:]
        
        let request : NSFetchRequest<NSFetchRequestResult> = NotificationEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try context.execute(deleteRequest)
        try context.save()
            
        print("Successfully cleared all Notifications from Core Data records.")
        
    }
    
    static func printAllCoreData(context: NSManagedObjectContext) {
        // Get all entities in the Core Data model
        guard let entities = context.persistentStoreCoordinator?.managedObjectModel.entities else {
            print("No entities found in the Core Data model.")
            return
        }
        
        for entity in entities {
            guard let entityName = entity.name else { continue }
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            
            do {
                let results = try context.fetch(fetchRequest)
                
                print("Entity: \(entityName) (\(results.count) objects)")
                for object in results {
                    print(object.dictionaryRepresentation())
                }
            } catch {
                print("Failed to fetch objects for entity \(entityName): \(error)")
            }
        }
    }
    
    static func clearUserDefaults() {
        let userDefaults = UserDefaults.standard
        let defaultsDictionary = userDefaults.dictionaryRepresentation()
        
        for key in defaultsDictionary.keys {
            userDefaults.removeObject(forKey: key)
        }
        
        userDefaults.synchronize() // Ensure changes are saved immediately
        print("UserDefaults cleared.")
    }
    
    static func printFilteredUserDefaults() {
        let userDefaults = UserDefaults.standard
        let defaultsDictionary = userDefaults.dictionaryRepresentation()

        print("Filtered UserDefaults Contents:")
        for (key, value) in defaultsDictionary {
            // Filter out system-generated keys
            if !key.starts(with: "Apple") && !key.starts(with: "NS") {
                print("\(key): \(value)")
            }
        }
    }

}

extension NSManagedObject {
    // Helper to convert an NSManagedObject into a dictionary for easier printing
    func dictionaryRepresentation() -> [String: Any] {
        var dict: [String: Any] = [:]
        for attribute in entity.attributesByName.keys {
            dict[attribute] = value(forKey: attribute)
        }
        return dict
    }
}

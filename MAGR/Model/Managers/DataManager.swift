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
    
    // MARK: Setting Up Persistent Storage
    private static let persistentContianer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private static var NotificationEntities: [String : NotificationEntity] = [:]
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
    
    /// Save the given Date to UserDefaults and DataManager dateOfLastNetwork
    static func setDateOfLastNetwork(_ date: Date) {
        defaults.set(date, forKey: K.userDefaults.lastNetworkDate)
        dateOfLastNetwork = date
    }
    
    /// Save the given Bool to UserDefaults and DataManager UserWantsNotifications
    static func setUserWantsNotifications(_ status: Bool) {
        defaults.set(status, forKey: K.userDefaults.userWantsNotitifications)
        userWantsNotifications = false
    }
    
}

// MARK: Persistent Storage Operations - CREATE
extension DataManager {
    
    /// Create a DateOfLastNetwork Date - save it to UserDefaults and DataManager
    static func createDateOfLastNetwork() {setDateOfLastNetwork(Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 9))!)}
    
    /// Create a UserWantsNotice Bool - save it to UserDefaults and DataManager
    static func createUserWantsNotice() {setUserWantsNotifications(false)}
    
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
    
    /// Grab dateOfLastNetwork from UserDefaults and create it if it doesnt exist. Get functions are UserDefaults, Load are Core Data
    /// Come back to this and verify that this is actually what you want
    static func getDateofLastNetwork() -> Date {
        
        if let _ = defaults.object(forKey: K.userDefaults.lastNetworkDate) as? Date {
            return dateOfLastNetwork
        }
        else {
            createDateOfLastNetwork()
            return dateOfLastNetwork
        }
    }
    
    /// Grab userWantsNotifications Bool from UserDefaults and create it if it doesnt exist.
    static func getUserWantsNotice() -> Bool {
        
        if let _ = defaults.object(forKey: K.userDefaults.userWantsNotitifications) as? Bool {
            return userWantsNotifications
        }
        else {
            
            return userWantsNotifications
        }
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
     - Note: If empty, create Notification Entities initialized to false for each of the 5 daily prayers
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
        
        print("Updating monthly\n")
        
        do {
            
            try clearMonthlyPrayerEntities()
            
            for dailyPrayers in prayers {
                MonthlyPrayerEntities.append(createMonthlyPrayerEntity(dailyPrayers))
            }
            
            MonthlyPrayerEntities.sort {$0.date! < $1.date!}
            
            print("Monthly Updated\n")
            saveDatabase()
            
        }
        catch {print("Could not clear monthly")}

    }
    
    /**
     Clears Daily Prayer times from Core Data and DataManager and repopulates them with updated values gotten from Firebase
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
            
            fajrToday.iqama = PrayerManager.processIqama(fajrToday)
            dhuhrToday.iqama = PrayerManager.processIqama(dhuhrToday)
            asrToday.iqama = PrayerManager.processIqama(asrToday)
            maghribToday.iqama = PrayerManager.processIqama(maghribToday)
            ishaToday.iqama = PrayerManager.processIqama(ishaToday)
            
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.fajr] = createDailyPrayerEntity(fajrToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.dhuhr] = createDailyPrayerEntity(dhuhrToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.asr] = createDailyPrayerEntity(asrToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.maghrib] = createDailyPrayerEntity(maghribToday)
            DailyPrayerEntities[K.FireStore.dailyPrayers.names.isha] = createDailyPrayerEntity(ishaToday)
            
            saveDatabase()
            
        } catch {print("Could not clear daily")}
        
    }
    
    /// Helper function to set the adhan times from MonthlyPrayerEntities by callling PrayerManager.getTodayAdhan()
    static func setTodayAdhanTimes() {
        let todayAdhanTimes = PrayerManager.getTodaysAdhanTimes()
        print(todayAdhanTimes)
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
            
            print("Need to Network for monthly prayers \n")
            
            do {
                let monthlyTimes = try await FirebaseManager.fetchAdhanTimes()
                updateMonthlyAdhanStorage(monthlyTimes)
                
            }
            catch{ print("Error handling Monthly: \(error)") }

        } else { 
            print("Do not need to network for monthly prayers\n")
            print(MonthlyPrayerEntities[0])
        }
    }
    
    
    /**
     Handle Daily Prayer Times. Choose between using Core Data values or fetching new values from Firebase
     - Note: Will always update DataManager TodayAdhan and TodayIqama properties
     */
    static func handleDaily() async {
        
        //Situation where need to network
        if DailyPrayerEntities.count == 0 || !Calendar.current.isDate(dateOfLastNetwork, inSameDayAs: Date()) {
            
            print("Need to Network for Daily prayers \n")
            
            do {
                
                let iqamaTimes = try await FirebaseManager.fetchIqamaTimes()
                updateDailyPrayerStorage(iqamaTimes)
                
            } catch { print("Error Handling Dailies: \(error)")}
        }
        else {
            print("Do not need to Network for daily prayers \n")
            setTodayAdhanTimes()
            fajrToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.fajr]?.iqama ?? "22:22 AM"
            dhuhrToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.dhuhr]?.iqama ?? "22:22 AM"
            asrToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.asr]?.iqama ?? "22:22 AM"
            maghribToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.maghrib]?.iqama ?? "22:22 AM"
            ishaToday.iqama = DailyPrayerEntities[K.FireStore.dailyPrayers.names.isha]?.iqama ?? "22:22 AM"
            
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
            print("Saved Database")
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
            
        print("Successfully cleared all MonthlyPrayers from Core Data records.")
    }
    
    static func clearDailyPrayerEntities() throws {
        
        DailyPrayerEntities = [:]

        let request : NSFetchRequest<NSFetchRequestResult> = DailyPrayerEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try context.execute(deleteRequest)
        try context.save()
            
        print("Successfully cleared all Daily Prayer Core Data records.")
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

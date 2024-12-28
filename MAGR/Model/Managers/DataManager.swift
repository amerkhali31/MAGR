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
    static var dateOfLastNetwork = Date()
    static var hadithNumber = "1"
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
    static var prayer_notification_preferences: [String: Bool] = [:]
    
    // MARK: Setting Up Persistent Storage
    private static let persistentContianer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var TodayPrayerEntities: TodayPrayerEntity?
    static var MonthlyPrayerEntities: [MonthlyPrayerEntity] = []
    static var AnnouncementEntities: [AnnouncementEntity] = []
    
    // MARK: Announcements
    static var urlList: [URL] = []
    static var urlImages: [UIImage] = []
    
    // MARK: Prayers
    static var currentPrayer: DailyPrayer = DailyPrayer()
    static var nextPrayer: DailyPrayer = DailyPrayer()
    
    static var fajrToday: DailyPrayer = DailyPrayer(name: K.DailyPrayerDisplayNames.fajr)
    static var dhuhrToday: DailyPrayer = DailyPrayer(name: K.DailyPrayerDisplayNames.dhuhr)
    static var asrToday: DailyPrayer = DailyPrayer(name: K.DailyPrayerDisplayNames.asr)
    static var maghribToday: DailyPrayer = DailyPrayer(name: K.DailyPrayerDisplayNames.maghrib)
    static var ishaToday: DailyPrayer = DailyPrayer(name: K.DailyPrayerDisplayNames.isha)
    
    static var khutbaToday: DailyPrayer = DailyPrayer(name: K.DailyPrayerDisplayNames.jumaa_khutba)
    static var jumaaToday: DailyPrayer = DailyPrayer(name: K.DailyPrayerDisplayNames.jumaa_salah)
    
    static var monthlyPrayers: [FirebaseOneDayAdhanTimes] = []
    
    // MARK: Date
    static var todaysDate: String = ""
    
    
    private init() {}
}

// MARK: Data Manager Operations - GET : Load values from UserDefaults into DataManager Variables
extension DataManager {
    
    /// Grab dateOfLastNetwork from UserDefaults and create it if it doesnt exist. Then assign it to DataManager.dateOfLastNetwork
    static func getDateofLastNetwork() {
        
        if let day = defaults.object(forKey: K.userDefaults.lastNetworkDate) as? Date {dateOfLastNetwork = day}
        else {setDateOfLastNetwork()}
    }
    
    /// Load user notification preferences from user defaults and set prayerNotificationPrefences accordingly. creates values if they dont exist already.
    static func loadUserNotificationPreferences() {
        for notice in notices {
            
            if let noticeStatus = defaults.object(forKey: notice) as? Bool {prayer_notification_preferences[notice] = noticeStatus}
            else {setSingleUserPreference(notice, false)}
        }
    }
    
    /// Grab hadithNumber String from UserDefaults and create it if it doesnt exist. Then assign it to DataManager.hadithNumber
    static func getHadithNumber() {
        if let number = defaults.object(forKey: K.userDefaults.hadithNumber) as? String {hadithNumber = number}
        else { setHadithNumber() }
    }
    
}

// MARK: Data Manager Operations - SET : Set values in UserDefaults
extension DataManager {
    
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
    
    /// Save the given preference to user defaults and Datamanager.prayernotificationpreferences
    static func setSingleUserPreference(_ name: String, _ status: Bool) {
        defaults.set(status, forKey: name)
        prayer_notification_preferences[name] = status
    }
    
}

// MARK: Persistent Storage Operations - CREATE : Create Entities to be stored in Core Data
extension DataManager {
    
    /// Create a TodayPrayerEntity from a FirebaseDailyPrayerTimes object
    static func createTodayPrayerEntity(_ prayerTimes: FirebaseDailyPrayerTimes) -> TodayPrayerEntity {
        
        let entity = TodayPrayerEntity(context: context)
        entity.fajr_adhan = prayerTimes.fajr_adhan
        entity.fajr_iqama = prayerTimes.fajr_iqama
        entity.dhuhr_adhan = prayerTimes.dhuhr_adhan
        entity.dhuhr_iqama = prayerTimes.dhuhr_iqama
        entity.asr_adhan = prayerTimes.asr_adhan
        entity.asr_iqama = prayerTimes.asr_iqama
        entity.maghrib_adhan = prayerTimes.maghrib_adhan
        entity.maghrib_iqama = prayerTimes.maghrib_iqama
        entity.isha_adhan = prayerTimes.isha_adhan
        entity.isha_iqama = prayerTimes.isha_iqama
        entity.jumaa_khutba = prayerTimes.jumaa_khutba
        entity.jumaa_salah = prayerTimes.jumaa_salah
        
        return entity
        
    }
    
    /// Create a MonthlyPrayerEntity from a FirebaseOneDayAdhanTimes Object
    static func createMonthlyPrayerEntity(_ prayers: FirebaseOneDayAdhanTimes) -> MonthlyPrayerEntity {
        
        let entity = MonthlyPrayerEntity(context: context)
        entity.fajr = prayers.fajr
        entity.dhuhr = prayers.dhuhr
        entity.asr = prayers.asr
        entity.maghrib = prayers.maghrib
        entity.isha = prayers.isha
        entity.date = prayers.date
        
        return entity
    }
    
    /// Create a list of AnnouncementEntity from a FirebaseAnnouncemebt Object
    static func createAnnouncementEntity(_ announcements: FirebaseAnnouncement) -> [AnnouncementEntity] {
        
        var entities: [AnnouncementEntity] = []
        for announcement in announcements.urls {
            let entity = AnnouncementEntity(context: context)
            entity.url = announcement
            entities.append(entity)
        }
        
        return entities
    }
    
}

// MARK: Persistent Storage Operations - READ : Load Entities from Core Data into DataManager Entity Variables
extension DataManager {
    
    /// Grab DailyPrayerEntities from Core Data and populate DataManager DailyPrayerEntities dict
    static func loadTodayPrayerEntities() {
        
        let request : NSFetchRequest<TodayPrayerEntity> = TodayPrayerEntity.fetchRequest()
        
        do { if let fetched_entity = try context.fetch(request).first {TodayPrayerEntities = fetched_entity} }
        catch {print("Error loading TodayPrayerEntities from CD: \(error)")}
        
    }
    
    /// Grab MonthlyPrayerEntities from Core Data and populate DataManager MonthlyPrayerEntities list
    static func loadMonthlyPrayerEntities() {
        
        let request : NSFetchRequest<MonthlyPrayerEntity> = MonthlyPrayerEntity.fetchRequest()
        
        do {
            
            let monthlyPrayerEntities = try context.fetch(request)
            for entity in monthlyPrayerEntities {MonthlyPrayerEntities.append(entity)}
            
            MonthlyPrayerEntities.sort {$0.date! < $1.date!}
            
        } catch { print("Error loading MonthlyPrayerEntities from CD: \(error)")}
        
    }
    
    /// Grab announcements from CD
    static func loadAnnouncementEntities() {
        
        let request : NSFetchRequest<AnnouncementEntity> = AnnouncementEntity.fetchRequest()
        
        do {
            
            let announcementEntities = try context.fetch(request)
            for entity in announcementEntities {AnnouncementEntities.append(entity)}
            
        } catch {print("Error loading TodayPrayerEntities from CD: \(error)")}
    }
    
}

// MARK: Persistent Storage Operations - UPDATE
extension DataManager {
    
    /**
     Clears Monthly Adhans from Core Data and DataManager. And replaces with new values gotten from Firebase
     - Note: Creates list of MonthlyPrayerEntity from list of provided `FirebaseMonthlyPrayer.
     - Note: Adds to DataManager.MonthlyPrayerEntities then saves data
     */
    static func updateMonthlyAdhanStorage(_ prayers: [FirebaseOneDayAdhanTimes]) {
                
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
    static func updateDailyPrayerStorage(_ prayers: FirebaseDailyPrayerTimes) {
        
        // Make sure there will be no duplicate or conflicting data
        do {
            
            try clearTodayPrayerEntities()
            
            
            fajrToday.adhan = prayers.fajr_adhan
            fajrToday.iqama = prayers.fajr_iqama
            dhuhrToday.adhan = prayers.dhuhr_adhan
            dhuhrToday.iqama = prayers.dhuhr_iqama
            asrToday.adhan = prayers.asr_adhan
            asrToday.iqama = prayers.asr_iqama
            maghribToday.adhan = prayers.maghrib_adhan
            maghribToday.iqama = prayers.maghrib_iqama
            ishaToday.adhan = prayers.isha_adhan
            ishaToday.iqama = prayers.isha_iqama
            jumaaToday.iqama = prayers.jumaa_salah
            khutbaToday.iqama = prayers.jumaa_khutba
            
            TodayPrayerEntities = createTodayPrayerEntity(prayers)

            
            saveDatabase()
            
        } catch {print("Could not clear daily")}
        
    }
    
    /// Update announcements
    static func updateAnnouncementStorage(_ announcements: FirebaseAnnouncement) {
        
        do {
            
            try clearAnnouncementEntities()
            for announcement in announcements.urls {
                if let safeUrl = URL(string: announcement) {urlList.append(safeUrl)}
            }
            AnnouncementEntities = createAnnouncementEntity(announcements)
            
        } catch {print("Could not clear Announcements")}
    }

    /**
     Handle Monthly Prayer Time Data. Choose between using Core Data values or fetching new values from Firebase
     - Note: If fetching new values, will update monthly prayer times, otherwise no need to change anything since we are just reading from entities variable which is populated when load is called
     */
    static func handleMonthly() async {
            
        if MonthlyPrayerEntities.count == 0 || TimeManager.getCurrentMonth() != TimeManager.getMonthofAdhan(MonthlyPrayerEntities) {
            
            let monthlyTimes = await FirebaseManager.fetchMonthlyAdhanTimes()
            updateMonthlyAdhanStorage(monthlyTimes)

        }
    }
    
    
    /**
     Handle Daily Prayer Times. Choose between using Core Data values or fetching new values from Firebase
     - Note: Will always update DataManager TodayAdhan and TodayIqama properties
     */
    static func handleDaily() async {
        
        //Situation where need to network
        if TodayPrayerEntities != nil || !Calendar.current.isDate(dateOfLastNetwork, inSameDayAs: Date()) {
            
            let prayerTimes = await FirebaseManager.fetchTodayPrayerTimes()
            updateDailyPrayerStorage(prayerTimes)

        }
        else {

            fajrToday.adhan = TodayPrayerEntities?.fajr_adhan ?? "22:22 AM"
            fajrToday.iqama = TodayPrayerEntities?.fajr_iqama ?? "22:22 AM"
            dhuhrToday.adhan = TodayPrayerEntities?.dhuhr_adhan ?? "22:22 AM"
            dhuhrToday.iqama = TodayPrayerEntities?.dhuhr_iqama ?? "22:22 AM"
            asrToday.adhan = TodayPrayerEntities?.asr_adhan ?? "22:22 AM"
            asrToday.iqama = TodayPrayerEntities?.asr_iqama ?? "22:22 AM"
            maghribToday.adhan = TodayPrayerEntities?.maghrib_adhan ?? "22:22 AM"
            maghribToday.iqama = TodayPrayerEntities?.maghrib_iqama ?? "22:22 AM"
            ishaToday.adhan = TodayPrayerEntities?.isha_adhan ?? "22:22 AM"
            ishaToday.iqama = TodayPrayerEntities?.isha_iqama ?? "22:22 AM"
            jumaaToday.iqama = TodayPrayerEntities?.jumaa_salah ?? "22:22 AM"
            khutbaToday.iqama = TodayPrayerEntities?.jumaa_khutba ?? "22:22 AM"
        }
        
    }
    
    
    /**
     Always network for announcement images. Updates DataManager.`urlList and urlImages
     */
    static func handleAnnouncements() async {
        
        
        if AnnouncementEntities.count == 0 || !Calendar.current.isDate(dateOfLastNetwork, inSameDayAs: Date()) {
            
            let announcements = await FirebaseManager.fetchAnnouncementImageURLs()
            updateAnnouncementStorage(announcements)
            
            
        }
        else {
            
            for entity in AnnouncementEntities {
                if let url = entity.url {
                    if let safeUrl = URL(string: url) {urlList.append(safeUrl)}
                }
            }
        }
        
        let images = await FirebaseManager.fetchAnnouncementImages(urlList)
        for image in images {
            DataManager.urlImages.append(image)
        }
    }
    
    
    /// hadith handling
    static func handleHadith() async {
        
        if !Calendar.current.isDate(dateOfLastNetwork, inSameDayAs: Date()) {
            let number = await FirebaseManager.fetchHadithNumber()
            setHadithNumber(number)
        }

        
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
    
    static func clearAnnouncementEntities() throws {
        AnnouncementEntities = []
        
        let request : NSFetchRequest<NSFetchRequestResult> = AnnouncementEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try context.execute(deleteRequest)
        try context.save()
    }
    
    static func clearMonthlyPrayerEntities() throws {
        
        MonthlyPrayerEntities = []
        
        let request : NSFetchRequest<NSFetchRequestResult> = MonthlyPrayerEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try context.execute(deleteRequest)
        try context.save()
            
        //print("Successfully cleared all MonthlyPrayers from Core Data records.")
    }
    
    static func clearTodayPrayerEntities() throws {
        
        TodayPrayerEntities = nil

        let request : NSFetchRequest<NSFetchRequestResult> = TodayPrayerEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        try context.execute(deleteRequest)
        try context.save()
            
        //print("Successfully cleared all Daily Prayer Core Data records.")
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

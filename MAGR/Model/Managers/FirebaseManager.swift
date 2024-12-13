//
//  FirebaseManager.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation
import FirebaseFirestore

/**
 This class will be responsible for all operations involving networking - particularly fetching dat from Firebase
 
 - Note: Used to encapsulate netowrking functionality. Data Processing not done here.
 ##Test Notes: All functions in this class have been unit tested and confirmed functional
 */
class FirebaseManager {

    static let db = Firestore.firestore()
    
    
    /**
     Retrieve all adhan times for this month from Firebase
     
     - Returns: List of ``FirebaseMonthlyPrayer`` objects that represent this current month's adhans for every single prayer.
     - Note: Daily Adhan times will be retreived from here, not firebase. So ensure this worked before fetching daily times.
     - Important: Check if list is empty during loading process to determine how to move forward.
     ## Test Notes: Unit Tested and Functional Confirmed
     */
    static func fetchAdhanTimes() async throws -> [FirebaseMonthlyPrayer]{
                
        var monthlyAdhan: [FirebaseMonthlyPrayer] = []
                
        let query = db.collection(K.FireStore.Collections.monthly_prayer_times)
        let raw_fetched_data = try await query.getDocuments()
                
        for doc in raw_fetched_data.documents {
            
            // Extract prayer times and date from the document
            let fajrAdhan = doc.data()[K.FireStore.monthlyPrayers.fajr] as! String
            let dhuhrAdhan = doc.data()[K.FireStore.monthlyPrayers.zuhr] as! String
            let asrAdhan = doc.data()[K.FireStore.monthlyPrayers.asr] as! String
            let maghribAdhan = doc.data()[K.FireStore.monthlyPrayers.maghrib] as! String
            let ishaAdhan = doc.data()[K.FireStore.monthlyPrayers.isha] as! String
            let date = doc.data()[K.FireStore.monthlyPrayers.date] as! String

            // Create a `FirebaseMonthlyPrayer` object for each document
            let oneDayAdhanTimes = FirebaseMonthlyPrayer(
                fajr: fajrAdhan,
                zuhr: dhuhrAdhan,
                asr: asrAdhan,
                maghrib: maghribAdhan,
                isha: ishaAdhan,
                date: date
            )

            // Add it to the array
            monthlyAdhan.append(oneDayAdhanTimes)
        }
        
        monthlyAdhan.sort { $0.date < $1.date }

        return monthlyAdhan
        
    }
    
    
    /**
     Retrieve all Iqama times for today from Firebase
     
     - Returns: Dict of [String: ``FirebasePrayer``] which is effectively used for[Prayer_Name : Prayer_Time]. Will have all 5 daily prayers and jumaa. Returns Empty list if failed.
     - Note: Daily Adhan times will be retreived from here, not firebase. So ensure this worked before fetching daily times.
     - Important: Adhan will be initialized to 99:99 AM for each prayer
     ## Test Notes: Unit Tested and Functional Confirmed
     */
    static func fetchIqamaTimes() async throws -> [String: FirebasePrayer] {
                
        var dailyPrayers: [String: FirebasePrayer] = [:]
                
        let query = db.collection(K.FireStore.Collections.prayer_times)
        let raw_fetched_data = try await query.getDocuments()
                
        for doc in raw_fetched_data.documents {
            
            let prayerName = doc.data()[K.FireStore.dailyPrayers.fields.name] as! String
            let prayerIqama = doc.data()[K.FireStore.dailyPrayers.fields.time] as! String
            dailyPrayers[prayerName] = FirebasePrayer(prayerName, prayerIqama)
        }
        
        DataManager.setDateOfLastNetwork(Date())

        return dailyPrayers
        
    }
    
    
    /**
     Retrieve all Announcement Image URL's from Firebase
     
     - Returns: List of Strings that each represent a URL that needs to be
     - Note: Daily Adhan times will be retreived from here, not firebase. So ensure this worked before fetching daily times.
     - Important: Adhan will be initialized to 99:99 AM for each prayer
     ## Test Notes: Unit Tested and Functional Confirmed
     */
    static func fetchAnnouncementImageURLs() async throws -> [String]{
        
        
        var urlList: [String] = []
        
        let query = db.collection(K.FireStore.Collections.announcements)
        let raw_fetched_data = try await query.getDocuments()
                
        for doc in raw_fetched_data.documents {
            
            urlList.append(doc.data()[K.FireStore.announcement.url] as! String)
        }
        
        return urlList
        
    }
    
    
    /**
     Fetches the announcement images for the provided list of URLs.
     
     This function downloads images from the provided URLs concurrently using async/await.
     
     - Parameter urlList: A list of URLs for the images.
     - Returns: A list of `UIImage` objects.
     - Throws: An error if any image fails to download.
     */
    static func fetchAnnouncementImages(_ urlList: [URL]) async throws -> [UIImage] {
        
        var urlImages: [UIImage] = []

        for url in urlList {
            
            async let image = fetchImage(from: url)
            
            if let fetchedImage = try await image {
                urlImages.append(fetchedImage)
            }
        }        

        return urlImages
    }
    
    
    /**
     Fetches a single image from the provided URL.

     - Parameter url: The URL to fetch the image from.
     - Returns: A `UIImage` object if the download is successful, or `nil` if it fails.
     - Throws: An error if the network request fails.
     */
    static func fetchImage(from url: URL) async throws -> UIImage? {
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
    
    
    private init() {}
}

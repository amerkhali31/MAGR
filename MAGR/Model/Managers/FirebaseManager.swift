//
//  FirebaseManager.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseMessaging
import Firebase

/**
 This class will be responsible for all operations involving networking - particularly fetching dat from Firebase
 
 - Note: Used to encapsulate netowrking functionality. Data Processing not done here.
 ##Test Notes: All functions in this class have been unit tested and confirmed functional
 */
class FirebaseManager {

    static let db = Firestore.firestore()
    
    ///Retrieves all adhan times for this month
    /// - Returns: ``[FirebaseOneDayAdhanTimes]`` list representing this month's adhan times for each prayer
    static func fetchMonthlyAdhanTimes() async -> [FirebaseOneDayAdhanTimes] {
        
        // Initialize an empty array for storing data to return
        var monthlyAdhanTimes: [FirebaseOneDayAdhanTimes] = []
        
        // Tell Firebase what collection you want to grab from
        let query = db.collection(K.FireStore.Collections.monthly_adhan_times.collection_name)
        
        do {
            
            // Grab the data
            let raw_fetched_data = try await query.getDocuments()
            
            // Set the data to the custom data type I made
            monthlyAdhanTimes = raw_fetched_data.documents.compactMap { document in
                try? document.data(as: FirebaseOneDayAdhanTimes.self)
            }
        } catch { print("Error fetching monthly adhan times: \(error)")}
        
        return monthlyAdhanTimes
    }
    
    
    ///Retrieve all prayer times for today from Firebase. Sets dateOfLastNetwork upon completion
    ///- Returns: ``FirebaseDailyPrayerTimes`` object representing all of todays adhan and iqama times as well as jumaa
    static func fetchTodayPrayerTimes() async -> FirebaseDailyPrayerTimes {
        
        var today_times = FirebaseDailyPrayerTimes()
        
        let query = db.collection(K.FireStore.Collections.todays_prayer_times.collection_name)
        
        do {
            
            let raw_fetched_data = try await query.getDocuments()
            guard let document = raw_fetched_data.documents.first else {return today_times}
            
            today_times = try document.data(as: FirebaseDailyPrayerTimes.self)
            
            DataManager.setDateOfLastNetwork(Date())
            
        } catch { print("Error fetching daily prayer times: \(error)")}
        
        return today_times
    }
    

    ///Fetch the hadith number from firebase
    ///- Returns: Number as a string so Hadith of The Day has a hadith number to call its api with
    static func fetchHadithNumber() async -> String {
        let query = db.collection(K.FireStore.Collections.hadiths.collection_name)
        do {
            
            let raw_fetched_data = try await query.getDocuments()
            return raw_fetched_data.documents[0].data()[K.FireStore.Collections.hadiths.hadith.fields.number] as! String
            
        } catch { print("Could not fetch hadithNumber: \(error)")}
        
        return "999"
    }
    
    
    ///Retrieve all Announcement Image URL's from Firebase
    /// - Returns: List of Strings that each represent a URL that needs to be
    static func fetchAnnouncementImageURLs() async -> FirebaseAnnouncement {
        
        var announcements = FirebaseAnnouncement()
        
        let query = db.collection(K.FireStore.Collections.announcements.collection_name)
        do {
            
            let raw_fetched_data = try await query.getDocuments()
            guard let document = raw_fetched_data.documents.first else { return announcements }
            
            do {announcements = try document.data(as: FirebaseAnnouncement.self)}
            
        } catch { print("Error fetching Announcement URLs: \(error)")}

        return announcements
        
    }
    
    
    /**
     Fetches the announcement images for the provided list of URLs.
     
     This function downloads images from the provided URLs concurrently using async/await.
     
     - Parameter urlList: A list of URLs for the images.
     - Returns: A list of `UIImage` objects.
     - Throws: An error if any image fails to download.
     */
    static func fetchAnnouncementImages(_ urlList: [URL]) async -> [UIImage] {
        var urlImages: [UIImage] = []

        // Create a task for each URL
        let tasks = urlList.map { url in
            Task {
                return await fetchImage(from: url) // No need for try here
            }
        }

        // Collect results concurrently
        for task in tasks {
            if let image = await task.value {
                urlImages.append(image)
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
    static func fetchImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error fetching image from URL \(url): \(error.localizedDescription)")
            return nil
        }
    }
    
    
    ///Subscripe to topics for notifications
    static func subscribeToTopic(topic: String) {
        
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {print("Failed to subscripe to \(topic) : \(error)")}
            else {print("Successfully subscribed to \(topic)")}
        }
    }
    
    
    ///Unsubscripe to topics for notifications
    static func unsubscribeToTopic(topic: String) {
        
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {print("Failed to unsubscripe to \(topic) : \(error)")}
            else {print("Successfully unsubscribed to \(topic)")}
        }
    }
    
    
    private init() {}
}

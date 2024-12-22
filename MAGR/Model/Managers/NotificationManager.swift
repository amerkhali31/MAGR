//
//  NotificationManager.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation

/**
 This class will be responsible for all operations involving Notifications - Particularly Scheuling, deleting, and printing
 */
import Foundation
import FirebaseFirestore
import CoreData

/**
 Will be responsible for managing all of the app's data. Performs reads and writes with Core Data
 
 Rest of the app will be getting it's information from here. All prayer times, notifications, and announcements are here.
 
 */
class NotificationManager {
    
    
    
    private static let center = UNUserNotificationCenter.current()
    
    static func requestNotificationPermission() {
        
        UNUserNotificationCenter.current().requestAuthorization(
          options: [.alert, .sound, .badge],
          completionHandler: { _, _ in } )
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission denied: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     Schedule a notification for a prayer
     - Note: Called in scheduleAllDailyNotifications as well
     - Parameters:
        - at: Date object with time representing when you would like the notification to be scheduled for
        - title: The top label text in the notification as it pops up in notification center
        - noticeIdentifier: how the notice will be called
     */
    static func scheduleNotification(at date: Date?, _ title: String, _ noticeIdentifier: String) {
        
        if let safeDate = date {
            
            // Define the content of the notification
            let content = UNMutableNotificationContent()
            content.title = "\(title)"
            content.body = "Adhan"
            content.sound = UNNotificationSound(named: UNNotificationSoundName("adhan.wav"))

            // Create the trigger based on the date
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: safeDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            // Create the request
            let request = UNNotificationRequest(identifier: noticeIdentifier, content: content, trigger: trigger)

            // Add the request to the notification center
            center.add(request) { error in
//                if let error = error {
//                    //print("Error scheduling notification: \(error.localizedDescription)")
//                } else {
                    print("\(title) Sceduled Notice: \(triggerDate). ID: \(noticeIdentifier)")
//                }
            }
        }
        else {print("Bad Date")}
        
    }
    
    /// Check if app has permissions to give notifications
    static func checkNotificationPermissions() async -> Bool {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
    }
    
    /// Clear all sceduled notifications and schedule new ones on top of them up to 64 notifications. app needs to open and be closed for this to work
    /// Clear all scheduled notifications and schedule new ones on top of them
    static func scheduleAllDailyNotifications() {
        
        // Clear all pending notifications to avoid duplication
        deleteAllNotifications()
        
        // Get all prayers with notifications enabled
        let enabledPrayers = DataManager.NotificationEntities.filter { $0.value.status }
        
        // Calculate the max number of days for notifications per prayer
        let day = TimeManager.getDayOfMonth()
        let monthlyEntities = DataManager.getMonthlyPrayerEntities()
        let daysLeftInMonthlyEntity = 1 + monthlyEntities.count - day
        
        let maxNotifications = 64
        let maxDaysPerPrayer = maxNotifications / max(1, enabledPrayers.count) // Avoid division by zero
        
        let numberOfDaysForNotification = min(daysLeftInMonthlyEntity,maxDaysPerPrayer)
        
       // print("Scheduling notifications for \(enabledPrayers.count) daily prayers, \(numberOfDaysForNotification) days each.")
        
        // Iterate over each enabled prayer
        for prayerNotification in enabledPrayers {
            
            guard let prayerName = prayerNotification.value.prayer else { print("Problem"); continue }
            
            for (index,monthlyEntity) in DataManager.getMonthlyPrayerEntities()[day-1..<day-1+numberOfDaysForNotification].enumerated() {
                
                switch prayerName {
                    
                case K.FireStore.dailyPrayers.names.fajr:
                    if let date = TimeManager.createDateFromDateAndTime(TimeManager.convert24HrTimeTo12HrTime(monthlyEntity.fajr ?? "00:00 AM"), monthlyEntity.date ?? "1999-09-27") {
                        scheduleNotification(at: date, "Fajr", "\(K.AdhanNotifications.fajrNotice)-\(day+index)")
                    }
                    
                case K.FireStore.dailyPrayers.names.dhuhr:
                    if let date = TimeManager.createDateFromDateAndTime(TimeManager.convert24HrTimeTo12HrTime(monthlyEntity.dhuhr ?? "00:00 AM"), monthlyEntity.date ?? "1999-09-27") {
                        scheduleNotification(at: date, "Dhuhr", "\(K.AdhanNotifications.dhuhrNotice)-\(day+index)")
                    }
                    
                case K.FireStore.dailyPrayers.names.asr:
                    if let date = TimeManager.createDateFromDateAndTime(TimeManager.convert24HrTimeTo12HrTime(monthlyEntity.asr ?? "00:00 AM"), monthlyEntity.date ?? "1999-09-27") {
                        scheduleNotification(at: date, "Asr", "\(K.AdhanNotifications.asrNotice)-\(day+index)")
                    }
                    
                case K.FireStore.dailyPrayers.names.maghrib:
                    if let date = TimeManager.createDateFromDateAndTime(TimeManager.convert24HrTimeTo12HrTime(monthlyEntity.maghrib ?? "00:00 AM"), monthlyEntity.date ?? "1999-09-27") {
                        scheduleNotification(at: date, "Maghrib", "\(K.AdhanNotifications.maghribNotice)-\(day+index)")
                    }
                    
                case K.FireStore.dailyPrayers.names.isha:
                    if let date = TimeManager.createDateFromDateAndTime(TimeManager.convert24HrTimeTo12HrTime(monthlyEntity.isha ?? "00:00 AM"), monthlyEntity.date ?? "1999-09-27") {
                        scheduleNotification(at: date, "Isha", "\(K.AdhanNotifications.ishaNotice)-\(day+index)")
                    }
                    
                default:
                    //print("Prayer name \(prayerName) not found when making a Notification")
                    continue
                }
                
            }
        }
    }

    
    /// Display all scheduled notifications and their details
    static func printScheduledNotifications() {
        //print("In printscheduled function")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            if requests.count == 0 {print("No Notifications Pending")}
            for request in requests {
                print("Pending Notification: \(request.identifier) - \(request.content.title) - \(request.trigger!)")
            }
        }
    }
    
    /// Delete all scheduled notifications from notification center
    static func deleteAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        //print("Cleared all Scheduled Notifications")
    }
    
    static func deleteNotification( _ noticeIdentifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [noticeIdentifier])
    }
        
    private init() {}
    
}

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
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("\(title) Notification scheduled successfully for \(triggerDate).")
                }
            }
        }
        else {print("Bad Date")}
        
    }
    
    /// Check if app has permissions to give notifications
    static func checkNotificationPermissions() async -> Bool {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
    }
    
    /// Clear all sceduled notifications and schedule new ones on top of them
    static func scheduleAllDailyNotifications() {
        
        // Get rid of the old notifications in notification center to avoid conflicts with new ones
        deleteAllNotifications()
        
        // Iterate all saved Notifications
        for prayerNotification in DataManager.NotificationEntities{
            
            // If the given prayer has notifications turned on
            if prayerNotification.value.status {
                print("From ScheduleAllNotifications:")
                
                // Assign notification per prayer name
                switch prayerNotification.value.prayer! {
                    
                case K.FireStore.dailyPrayers.names.fajr:
                    
                    let date = TimeManager.createDateFromTime(DataManager.getFajrToday().adhan)
                    scheduleNotification(at: date, "Fajr", K.AdhanNotifications.fajrNotice)

                case K.FireStore.dailyPrayers.names.dhuhr:
                    
                    let date = TimeManager.createDateFromTime(DataManager.getDhuhrToday().adhan)
                    scheduleNotification(at: date, "Zuhr", K.AdhanNotifications.dhuhrNotice)

                case K.FireStore.dailyPrayers.names.asr:
                    
                    let date = TimeManager.createDateFromTime(DataManager.getAsrToday().adhan)
                    scheduleNotification(at: date, "Asr", K.AdhanNotifications.asrNotice)

                case K.FireStore.dailyPrayers.names.maghrib:
                    
                    let date = TimeManager.createDateFromTime(DataManager.getMaghribToday().adhan)
                    scheduleNotification(at: date, "Maghrib", K.AdhanNotifications.maghribNotice)

                case K.FireStore.dailyPrayers.names.isha:
                    
                    let date = TimeManager.createDateFromTime(DataManager.getIshaToday().adhan)
                    scheduleNotification(at: date, "Isha", K.AdhanNotifications.ishaNotice)

                default: print("Prayer name not found when making a Notification")
                    
                }
            }
        }
    }
    
    /// Display all scheduled notifications and their details
    static func printScheduledNotifications() {
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
    }
    
    static func deleteNotification( _ noticeIdentifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [noticeIdentifier])
    }
        
    private init() {}
    
}

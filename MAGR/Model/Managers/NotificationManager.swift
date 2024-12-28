//
//  NotificationManager.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation
import FirebaseFirestore
import CoreData

/// Mostly Deprecated. Keeping just in case further notification capability is to be added in the future
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
//                    print("\(title) Sceduled Notice: \(triggerDate). ID: \(noticeIdentifier)")
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

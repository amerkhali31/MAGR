//
//  TimeManager.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation

/**
 This class is responsible for all operations involving processing Dates and Times.
 */
class TimeManager {
    
    /// Get today's date in yyyy-MM-dd format
    static func getTodaysDate() -> String {
                
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: Date())
    }

    
    /// Return the number of the month of the adhan's currently saved to Core Data
    static func getMonthofAdhan(_ monthlyList: [MonthlyPrayerEntity]) -> String {
        return String(monthlyList[0].date!.split(separator: "-")[1])
    }
    
    /// Return the number of the current month in real time as a string
    static func getCurrentMonth() -> String {
        return String(Calendar.current.component(.month, from: Date()))
    }
    
    /// Get the day of the month
    static func getDayOfMonth() -> Int{
        return Calendar.current.component(.day, from: Date())
    }
    
    /// Get the string name of the month
    static func getMonthName(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid Date"
        }
        
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }
    
    /// Convert a date in yyyy-MM-dd to the english version of that date with option to include the year
    static func formatDateToReadable(_ dateString: String, _ includeYear: Bool) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        // Convert string to Date
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }

        // Extract the day for suffix and year
        let calendar = Calendar.current
        guard let day = calendar.dateComponents([.day], from: date).day else {
            return nil
        }
        let year = calendar.component(.year, from: date)

        // Determine the suffix
        let suffix: String
        switch day {
        case 11, 12, 13: suffix = "th" // Special cases
        default:
            switch day % 10 {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }

        // Convert Date to desired format
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d"
        var formattedDate = outputFormatter.string(from: date)

        // Add suffix and optionally the year
        formattedDate += suffix
        if includeYear {
            formattedDate += ", \(year)"
        }

        return formattedDate
    }

    /// Get the given 12hr time string as secons passed since midnight.
    /// - Note: Helper function for getCurrentTimeAsSecondsFromMidnight as well as time until next prayer
    static func convertTimeToSeconds(_ timeString: String) -> Int {
        
        // convert given 12Hr time string To Int seconds from midnight
        
        // Initialize time variables
        var totalSeconds: Int = 0
        var hours = 0
        var minutes = 0
        var seconds = 0
        
        // Separate the number from the AM/PM sign
        let components = timeString.split(separator: " ")
        
        // Check if timeString was actually safe to split and process
        if components.count != 2 { return 0}
        
        // Get the number and sign individually
        let timeComponent = components[0]
        let ampm = components[1]
        
        // Break the time into hours, minutes, seconds
        let timeComponents = timeComponent.split(separator: ":")
        
        // Get the hours, minutes, and seconds components individually
        hours = Int(timeComponents[0]) ?? 0
        minutes = Int(timeComponents[1]) ?? 0
        if timeComponents.count == 3 {seconds = Int(timeComponents[2]) ?? 0}
        
        // Process the hours
        if ampm == "PM" && hours != 12 {hours += 12}
        else if ampm == "AM" && hours == 12 {hours = 0}
        
        // Calculate the total time
        totalSeconds = seconds + (60 * minutes) + (3600 * hours)
        return totalSeconds
    }
    
    /// Used for getting current prayer.
    static func getCurrentTimeAsSecondsFromMidnight() -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:ss a"
        
        let dateAsTime = convertTimeToSeconds(formatter.string(from: Date()))
        
        return dateAsTime
    }
    
    ///Get the date on the islamic calendar system
    static func convertToIslamicDate(from gregorianDate: Date) -> String? {
        // Define the Islamic (Hijri) calendar
        let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)

        // Extract Islamic date components
        let islamicComponents = islamicCalendar.dateComponents([.year, .month, .day], from: gregorianDate)

        // Format the date in Islamic calendar
        if let year = islamicComponents.year, let month = islamicComponents.month, let day = islamicComponents.day {
            let formatter = DateFormatter()
            formatter.calendar = islamicCalendar
            formatter.dateFormat = "MMMM d, yyyy" // Customize format as needed
            
            // Convert the components back into a Date object
            if let hijriDate = islamicCalendar.date(from: islamicComponents) {
                return formatter.string(from: hijriDate)
            } else {
                return "\(day) \(month) \(year)"
            }
        }

        return nil
    }
    
    /// Convert seconds to Hours:Minutes:seconds
   static func convertSecondsToTime(_ totalSeconds: Int) -> (hours: Int, minutes: Int, seconds: Int) {
        let hours = totalSeconds / 3600 // Takes int/int so returns int whole number
        let minutes = (totalSeconds % 3600) / 60 // %3600 gets the number of seconds left after removing all hours. then divide by 60 to get the whole number of minutes
        let seconds = totalSeconds % 60
        return (hours, minutes, seconds)
    }
    
    /// Helper function for Schedulting All Notifications. Takes input string time in hours minutes seconds (not day) of desired notification returns date
    static func createDateFromTime(_ timeString: String) -> Date? {
        
        // Get Current Date
        let calendar = Calendar.current
        let now = Date()
        
        // Parse the Time String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        guard let timeDate = dateFormatter.date(from: timeString) else {return nil}
        
        // Extract hours and minutes from parsed time string
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
        
        // Get todays date
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        
        // Set the desired time to parsed time string on today
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = 0
        
        return calendar.date(from: components)
    }
    
    /**
     Updated version of createDateFromTime. Give it a time and a date as a string and it will give you the date and time as a Date object. used for schedul all notifications
     */
    static func createDateFromDateAndTime(_ timeString: String, _ dateString: String) -> Date? {
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        guard let time = timeFormatter.date(from: timeString) else {return nil}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: dateString) else {return nil}
        
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        var Datecomponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        Datecomponents.hour = timeComponents.hour
        Datecomponents.minute = timeComponents.minute
        
        return Calendar.current.date(from: Datecomponents)
    }
    
    /// used in checking if should network for month data
    static func isCurrentMonth(_ dateString: String?) -> Bool {
        guard let dateString = dateString else { return false }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else { return false }
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        let entityMonth = calendar.component(.month, from: date)
        let entityYear = calendar.component(.year, from: date)
        
        return currentYear == entityYear && currentMonth == entityMonth
    }
    
    
    private init() {}
}

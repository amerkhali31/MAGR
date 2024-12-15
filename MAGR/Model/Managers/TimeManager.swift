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
    
    /// Takes a time string in military time and returns it as AM/PM time
    static func convert24HrTimeTo12HrTime(_ time: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let time12hr = formatter.date(from: time) else {return "00:99 PM"}
        
        formatter.dateFormat = "h:mm a"
        let newTime = formatter.string(from: time12hr)
        
        return newTime
    }
    
    /// Return the number of the month of the adhan's currently saved to Core Data
    static func getMonthofAdhan(_ monthlyList: [MonthlyPrayerEntity]) -> String {
        return String(monthlyList[0].date!.split(separator: "-")[1])
    }
    
    /// Return the number of the current month in real time as a string
    static func getCurrentMonth() -> String {
        return String(Calendar.current.component(.month, from: Date()))
    }
    
    static func getMonthName(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return "Invalid Date"
        }
        
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }
    
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

    
    private init() {}
}

//
//  DailyPrayer.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation


/**
 Representation of one Daily prayer. Default name Fajr and times 98:76 PM. Will be used for displaying single day prayer times accross app
 
 - Parameters:
    - name: The name of the prayer
    - adhan: The adhan time of the prayer as a string
    - iqama: The iqama time of the specific masjid as a string
 */
struct DailyPrayer {
    
    let name: String
    var adhan: String
    var iqama: String
    
    init(name: String = "Fajr", adhan: String = "98:76 PM", iqama: String = "98:76 PM") {
        self.name = name
        self.adhan = adhan
        self.iqama = iqama
    }
}

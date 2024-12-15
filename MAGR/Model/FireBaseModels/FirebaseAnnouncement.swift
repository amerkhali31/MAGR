//
//  FirebaseAnnouncement.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//

import Foundation

/**
 The basic structure that a single announcement is stored as in Firebase.
 
 - Note: Convert whatever comes from announcements Firebase collection to a FirebaseAnnouncement object to be used in the app.
 - Note: The string represents a url that needs hosts the image to grab.
 - Important: Similar structure to AnnouncementEntity but not the same thing. Need to create that seperately.
 */
struct FirebaseAnnouncement {
    
    var url: String
    
}